class_name ThumbnailGen
extends SubViewport


const PREVIEW_SIZE = Vector2i( 512, 512 )
const THUMBNAILS_PATH = "thumbnails"
const CAM_DISTANCE_MULT := 0.4

@onready var camera = $Camera3D


func _ready():
	var dir_access := DirAccess.open( "res://" )
	if not dir_access.dir_exists( THUMBNAILS_PATH ):
		dir_access.make_dir( THUMBNAILS_PATH )


func generate_thumbnail( file_path : StringName, file_name : StringName, file_format : StringName ) -> String:
	var thumbnail_path : String = "DEFAULT"
	
	# Gnerate thumbnail for a 3D file
	if file_format == "glb" or file_format == "gltf":
		# Import file
		var gltf_document_load = GLTFDocument.new()
		var gltf_state_load = GLTFState.new()
		var error = gltf_document_load.append_from_buffer( FileAccess.get_file_as_bytes( file_path ), "", gltf_state_load )
		var gltf_scene_root_node : Node3D
		if error == OK:
			gltf_scene_root_node = gltf_document_load.generate_scene( gltf_state_load )
			add_child( gltf_scene_root_node )
		else:
			assert( "Couldn't load glTF scene (error code: %s)." % error_string(error) )
		
		# Set camera position and rotation
		var distance : float = abs( get_biggest_mesh_size( gltf_scene_root_node ) / sin( camera.fov / 2.0 ) )
		distance *= CAM_DISTANCE_MULT
		camera.position = Vector3( distance, distance, distance )
		camera.size = distance
		camera.look_at( Vector3.ZERO )
	
		# Save a render of the camera
		await RenderingServer.frame_pre_draw
		
		set_update_mode( SubViewport.UPDATE_ALWAYS )

		await RenderingServer.frame_post_draw

		set_update_mode( SubViewport.UPDATE_DISABLED )

		var thumbnail: Texture2D = get_texture()
		#thumb_created.emit(texture)
		
		thumbnail_path = THUMBNAILS_PATH + GlobalData.slash_sign + file_name + ".png"
		thumbnail.get_image().save_png( thumbnail_path )
		
		gltf_scene_root_node.hide()
		gltf_scene_root_node.queue_free()
	# Gnerate thumbnail for a 2D file
	elif file_format in [ "png", "jpg", "jpep", "bmb", "svg" ]:
		thumbnail_path = file_path
	
	return thumbnail_path



func get_mesh_size( mesh : Node ) -> float:
	if mesh.is_class( "MeshInstance3D" ):
		return mesh.get_aabb().get_longest_axis_size()
	else:
		return 0.0


func get_biggest_mesh_size( node : Node ) -> float:
	var biggest_size : float = 0.0
	
	var new_size : float = get_mesh_size( node )
	if new_size > biggest_size:
		biggest_size = new_size
	
	for child in node.get_children():
		new_size = get_mesh_size( child )
		if new_size > biggest_size:
			biggest_size = new_size
		if child.get_child_count() > 0:
			new_size = get_biggest_mesh_size( child )
			if new_size > biggest_size:
				biggest_size = new_size
	
	return biggest_size
