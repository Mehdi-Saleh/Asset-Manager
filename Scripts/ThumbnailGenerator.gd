class_name ThumbnailGen
extends Node


const PREVIEW_SIZE = Vector2i( 512, 512 )
const THUMBNAILS_PATH = "thumbnails/"

#var _viewport : SubViewport = null
@onready var _viewport : SubViewport = $SubViewport


func generate_thumbnail( file_path : StringName, file_name : StringName ) -> StringName:
	#var thumbnail := _generate_from_path( file_path, PREVIEW_SIZE, {} )
	
	#var new_scene := PackedScene.new()
	#var image : PackedByteArray = FileAccess.get_file_as_bytes( file_path )
	
	var image : TextureRect = TextureRect.new()
	image.texture = ImageTexture.create_from_image( Image.load_from_file( file_path ) )
	_viewport.add_child( image )
	
	
	await RenderingServer.frame_pre_draw
	
	_viewport.set_update_mode( SubViewport.UPDATE_ALWAYS )

	await RenderingServer.frame_post_draw

	_viewport.set_update_mode( SubViewport.UPDATE_DISABLED )

	var thumbnail: Texture2D = _viewport.get_texture()
	#thumb_created.emit(texture)
	
	thumbnail.get_image().save_png( THUMBNAILS_PATH + file_name + ".png" )
	
	return "Thumbnail path"


