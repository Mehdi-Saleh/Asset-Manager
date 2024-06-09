class_name SidePanel
extends PanelContainer

@export var open_panel_button : Button
@export var main_split_container : SplitContainer
@export var tag_scene : PackedScene

@onready var preview : TextureRect = $MarginContainer/ScrollContainer/VBoxContainer/MarginContainer/Preview
@export var default_preview_pic_location : StringName
@onready var title : Label = $MarginContainer/ScrollContainer/VBoxContainer/Name
@onready var location : Label = $MarginContainer/ScrollContainer/VBoxContainer/Location
@onready var type : Label = $MarginContainer/ScrollContainer/VBoxContainer/Type
@onready var license : Label = $MarginContainer/ScrollContainer/VBoxContainer/License
@onready var tags_parent : Node = $MarginContainer/ScrollContainer/VBoxContainer/Tags
@onready var tag_label : Button = $MarginContainer/ScrollContainer/VBoxContainer/Tags/Tag


var current_item : Dictionary


func _ready():
	SignalBus.side_panel = self


func open_panel():
	show()
	open_panel_button.hide()
	main_split_container.dragger_visibility = SplitContainer.DRAGGER_VISIBLE


func close_panel():
	hide()
	#open_panel_button.show()
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
	
	# TODO needs optimization
	var tag_items : Array = tags_parent.get_children()
	# As the to last objects are expected to be AddTag and TagLineEdit
	var add_tag_button : Node = tag_items.pop_back()
	var tag_line_edit : Node = tag_items.pop_back()
	var tag_label : Node = tag_items.pop_front()
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
		
	# Put these back at the end
	tags_parent.remove_child( add_tag_button )
	tags_parent.remove_child( tag_line_edit )
	tags_parent.add_child( add_tag_button )
	tags_parent.add_child( tag_line_edit )


func get_current_item_id() -> int:
	return current_item[ "id" ]


func _on_close_side_panel_pressed():
	close_panel()


func _on_open_side_panel_pressed():
	open_panel()
