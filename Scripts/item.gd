class_name Item
extends Node


@export var picture : TextureRect
@export var open_button : Button
@export var folder_button : Button
@export var name_text : Label
@export var type_text : Label
@export var license_text : Label
@export var tags_parent : Node


var file_name : StringName
var type : StringName
var license : StringName
var location : StringName
var pic_location : StringName


# Initializes all values and applies them
func initialize( file_name:StringName, type:StringName, license:StringName, location:StringName, pic_location:StringName, tags:Array):
	# Set values
	self.file_name = file_name;
	self.location = location;
	self.pic_location = pic_location;
	self.type = type;
	self.license = license;

	# self.tags.Clear();
	# self.tags = tags.ToList();

	# Apply
	name_text.text = file_name;
	type_text.text = type;
	license_text.text = license;
	
	if type == "Graphic2D":
		load_thumbnail()
	
	
# Loads thumbnail from given location
func load_thumbnail():
	var image = Image.new()
	picture.texture = ImageTexture.create_from_image( image.load_from_file( location + "/" + file_name ) ) # TODO change to pic_location
