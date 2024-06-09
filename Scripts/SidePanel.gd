class_name SidePanel
extends PanelContainer

@export var open_panel_button : Button
@export var main_split_container : SplitContainer

@onready var preview : TextureRect = $MarginContainer/ScrollContainer/VBoxContainer/MarginContainer/Preview
@export var default_preview_pic_location : StringName
@onready var title : Label = $MarginContainer/ScrollContainer/VBoxContainer/Name
@onready var location : Label = $MarginContainer/ScrollContainer/VBoxContainer/Location
@onready var type : Label = $MarginContainer/ScrollContainer/VBoxContainer/Type
@onready var license : Label = $MarginContainer/ScrollContainer/VBoxContainer/License
@onready var tags_praent : Node = $MarginContainer/ScrollContainer/VBoxContainer/Tags
@onready var tag_label : Label = $MarginContainer/ScrollContainer/VBoxContainer/Tags/Tag


var current_item : Dictionary


func _ready():
	SignalBus.side_panel = self


func open_panel():
	show()
	open_panel_button.hide()
	main_split_container.dragger_visibility = SplitContainer.DRAGGER_VISIBLE


func close_panel():
	hide()
	open_panel_button.show()
	main_split_container.dragger_visibility = SplitContainer.DRAGGER_HIDDEN


func show_item( item_id : int):
	open_panel()
	
	current_item = DatabaseManager.get_item_by_id( item_id )
	
	# Set preview image
	var image = Image.new()
	if current_item[ "type" ] == "Graphic2D":
		preview.texture = ImageTexture.create_from_image( image.load_from_file( current_item[ "location" ] + "/" + current_item[ "name" ] ) ) # TODO change to pic_location
	else:
		preview.texture = ImageTexture.create_from_image( image.load_from_file( default_preview_pic_location ) )
	
	# Set labels values
	title.text = current_item[ "name" ]
	location.text = "Location: " + current_item[ "location" ] + "/" + current_item[ "name" ]
	type.text = "Type: " + current_item[ "type" ]
	license.text = "License: " + current_item[ "license" ]
	
	# TODO Set tags
	


func get_current_item_id() -> int:
	return current_item[ "id" ]


func _on_close_side_panel_pressed():
	close_panel()


func _on_open_side_panel_pressed():
	open_panel()
