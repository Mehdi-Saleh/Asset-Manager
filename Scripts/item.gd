class_name Item
extends Node


@export var picture : TextureRect
@export var open_button : Button
@export var folder_button : Button
@export var name_text : Label
@export var type_text : Label
@export var license_text : Label
@export var tags_parent : Node

@export var default_pic_location : StringName

var file_name : StringName
var type : StringName
var license : StringName
var location : StringName
var pic_location : StringName

var item_id : int = -1 # Used by the item manager for indexing

## Initializes all values and applies them to the item object.
func initialize( item_id:int, file_name:StringName, type:StringName, license:StringName, location:StringName, pic_location:StringName, tags:Array):
	# Set values
	self.item_id = item_id
	self.file_name = file_name;
	self.location = location;
	self.pic_location = pic_location;
	self.type = type;
	self.license = license;

	# TODO tags
	# self.tags.Clear();
	# self.tags = tags.ToList();

	# Apply
	name_text.text = file_name;
	type_text.text = type;
	license_text.text = license;
	load_thumbnail()	
	
	
# TODO thumbnail generation
## Loads thumbnail from pic_location.
func load_thumbnail():
	var image = Image.new()
	if type == "Graphic2D": 
		picture.texture = ImageTexture.create_from_image( image.load_from_file( location + "/" + file_name ) ) # TODO change to pic_location
	else:
		picture.texture = ImageTexture.create_from_image( image.load_from_file( default_pic_location ) )
