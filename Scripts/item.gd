class_name Item
extends Control


@export var preview : TextureRect
@export var open_button : Button
@export var folder_button : Button
@export var name_text : Label
@export var type_text : Button
@export var license_text : Button
@export var tags_parent : Node
@export var tag_scene : PackedScene

@export var default_pic_location : StringName


var name_str : StringName
var file_name : StringName
var type : StringName
var license : StringName
var location : StringName
var pic_location : StringName

var item_id : int = -1 # Used by the item manager for indexing

## Initializes all values and applies them to the item object.
func initialize( item_id:int, name:StringName, file_name:StringName, type:StringName, license:StringName, location:StringName, pic_location:StringName, auto_add_tags:bool = true):
	# Set values
	self.item_id = item_id
	self.name_str = name
	self.file_name = file_name
	self.location = location
	self.pic_location = pic_location
	self.type = type
	self.license = license

	# TODO needs optimization
	var tag_items : Array = tags_parent.get_children()
	var tags : Array = DatabaseManager.get_tags_by_id( item_id )
	# Instanciate new tag items if needed
	if tags.size() > tag_items.size():
		var dif : int = tags.size() - tag_items.size()
		for i in range( dif ):
			var new_tag : TagItem = tag_scene.instantiate()
			tags_parent.add_child( new_tag )
			tag_items.append( new_tag )
	# Set tags
	for i in range( 0, tags.size() ):
		tag_items[ i ].set_tag( tags[ i ] )
		tag_items[ i ].show()
	# Disable extra tag items
	for i in range( tags.size(), tag_items.size() ):
		tag_items[ i ].hide()

	# Apply
	name_text.text = name_str;
	type_text.text = type;
	license_text.text = license;
	load_thumbnail()	
	
	
# TODO thumbnail generation
## Loads thumbnail from pic_location.
func load_thumbnail():
	var image = Image.new()
	if type == "Graphic2D": 
		preview.texture = ImageTexture.create_from_image( image.load_from_file( location + GlobalData.slash_sign + file_name ) ) # TODO change to pic_location
	else:
		preview.texture = ImageTexture.create_from_image( image.load_from_file( default_pic_location ) )



func _on_preview_pressed():
	SignalBus.receive_signal( "show_in_side_panel", { "id" : item_id } )


func _on_open_folder_pressed():
	OS.shell_show_in_file_manager( location )


func _on_type_pressed():
	SignalBus.receive_signal( "show_items", { "items" : DatabaseManager.get_items_by_type( type ),
	"new_search_text" : ItemsManager.COMMAND_TYPE + type } )


func _on_license_pressed():
	SignalBus.receive_signal( "show_items", { "items" : DatabaseManager.get_items_by_license( license ),
	"new_search_text" : ItemsManager.COMMAND_LICENSE + license } )
