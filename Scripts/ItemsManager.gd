extends Node

@export var item_scene : PackedScene
@export var items_parent : Node
@export var search_text : LineEdit

var items_active : Array[Item]
var items_inactive : Array[Item]

# Called when the node enters the scene tree for the first time.
#func _ready():
	#update_items()

func instanciate_item( file_name:StringName, type:StringName, license:StringName, location:StringName, pic_location, tags:PackedStringArray ) -> Item:
	if items_inactive.is_empty():
		items_inactive.append( item_scene.instantiate() )
		items_parent.add_child( items_inactive.back() )
	
	var new_item : Item = items_inactive.pop_back()
		
	new_item.initialize( items_active.size(), file_name, type, license, location, pic_location, tags )
	new_item.show()
	items_active.append( new_item )
	return new_item


func remove_item( item : Item ):
	items_active.remove_at( item.item_id )
	items_inactive.append( item )
	item.hide()
	

func clear_items():
	for i in range( items_active.size()-1, -1, -1):
		items_active[i].hide()
		items_inactive.append( items_active[i] )
	items_active.clear()


func update_items( items : Array[Dictionary] ):
	clear_items()
	for item in items:
		instanciate_item( item["name"], item["type"], item["license"], item["location"], item["pic_location"], PackedStringArray() )


#func _on_tab_container_tab_selected(tab):
	#if tab == 0:
		#update_items()


func _on_search_button_pressed():
	var tags := search_text.text.split( " ", false )
	update_items( DatabaseManager.get_items_by_tag( tags ) )
	
