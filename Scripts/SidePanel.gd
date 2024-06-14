class_name SidePanel
extends PanelContainer

@export var open_panel_button : Button
@export var main_split_container : SplitContainer
@export var tag_scene : PackedScene

@onready var preview : TextureRect = $MarginContainer/ScrollContainer/VBoxContainer/MarginContainer/Preview
@export var default_preview_pic : Image
@onready var title : EditableLabel = $MarginContainer/ScrollContainer/VBoxContainer/Name
@onready var location : Button = $MarginContainer/ScrollContainer/VBoxContainer/Location
@onready var type : EditableLabel = $MarginContainer/ScrollContainer/VBoxContainer/Type/Type
@onready var license : EditableLabel = $MarginContainer/ScrollContainer/VBoxContainer/License/License
@onready var tags_parent : Node = $MarginContainer/ScrollContainer/VBoxContainer/Tags
@onready var tag_label : Button = $MarginContainer/ScrollContainer/VBoxContainer/Tags/Tag


var current_item : Dictionary


func _ready():
	SignalBus.side_panel = self
	
	title.change_item.connect( on_label_changed )
	type.change_item.connect( on_label_changed )
	license.change_item.connect( on_label_changed )


func open_panel():
	show()
	#open_panel_button.hide()
	main_split_container.dragger_visibility = SplitContainer.DRAGGER_VISIBLE


func close_panel():
	hide()
	#open_panel_button.show()
	main_split_container.dragger_visibility = SplitContainer.DRAGGER_HIDDEN


func show_item( item_id : int):
	open_panel()
	
	current_item = DatabaseManager.get_item_by_id( item_id )
	
	# Set preview image
	if current_item[ "type" ] == "Graphic2D":
		preview.texture = ImageTexture.create_from_image( Image.load_from_file( current_item[ "pic_location"] ) ) # TODO change to pic_location
	else:
		preview.texture = ImageTexture.create_from_image( default_preview_pic )
	
	# Set labels values
	title.text = current_item[ "name" ]
	location.text = "Location: " + current_item[ "location" ] + GlobalData.slash_sign + current_item[ "real_name" ]
	type.text = current_item[ "type" ]
	license.text = current_item[ "license" ]
	
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


func remove_item():
	DatabaseManager.remove_asset( current_item[ "id" ] )
	SignalBus.receive_signal( "reload_items" )


func _on_close_side_panel_pressed():
	close_panel()


func _on_open_side_panel_pressed():
	open_panel()


func _on_location_pressed():
	OS.shell_show_in_file_manager( current_item[ "location" ] + GlobalData.slash_sign + current_item[ "real_name" ] )


func _on_type_pressed():
	SignalBus.receive_signal( "show_items", { "items" : DatabaseManager.get_items_by_type( current_item[ "type" ] ),
	 "new_search_text" : ItemsManager.COMMAND_TYPE + current_item[ "type" ] } )


func _on_license_pressed():
	SignalBus.receive_signal( "show_items", { "items" : DatabaseManager.get_items_by_license( current_item[ "license" ] ),
	"new_search_text" : ItemsManager.COMMAND_LICENSE + current_item[ "license" ] } )


func on_label_changed( whats_the_label_for : StringName, new_value : String ):
	var new_item := current_item.duplicate()
	new_item[ whats_the_label_for ] = new_value
	DatabaseManager.update_item( current_item[ "id" ], new_item )


func _on_remove_button_pressed():
	remove_item()
