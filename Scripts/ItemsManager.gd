class_name ItemsManager
extends Node

const COMMAND_TAG := ":tag "
const COMMAND_TYPE := ":type "
const COMMAND_LICENSE := ":license "

@export var item_scene : PackedScene
@export var items_parent : Node
@export var search_text : LineEdit

var items_active : Array[Item]
var items_inactive : Array[Item]


func _ready():
	SignalBus.items_manager = self
	
	SignalBus.receive_signal( "show_all_items" )


## Instanciates a new item object with the given values. (Objects are pooled.)
func instanciate_item( item_id:int, file_name:StringName, type:StringName, license:StringName, location:StringName, pic_location ) -> Item:
	# Create a new item object if none are available
	if items_inactive.is_empty():
		items_inactive.append( item_scene.instantiate() )
		items_parent.add_child( items_inactive.back() )
	
	var new_item : Item = items_inactive.pop_back()
		
	# Initialize the item
	new_item.initialize( item_id, file_name, type, license, location, pic_location )
	new_item.show()
	items_active.append( new_item )
	return new_item


## Disables the given item objects and adds it back to the pool.
func remove_item( item : Item ):
	items_active.remove_at( item.item_id )
	items_inactive.append( item )
	item.hide()
	

## Disables all active item objects and adds them back to the pool.
func clear_items():
	for i in range( items_active.size()-1, -1, -1):
		items_active[i].hide()
		items_inactive.append( items_active[i] )
	items_active.clear()


## Instanciates item objects but does not clear previous ones.
func append_items( items : Array[Dictionary] ):
	for item in items:
		instanciate_item( item[ "id" ], item[ "name" ], item[ "type" ], item[ "license" ], item[ "location" ], item[ "pic_location" ] )


## Clears and re-instanciates all item objects.
func update_items( items : Array[Dictionary] ):
	clear_items()
	append_items( items )


#func _on_tab_container_tab_selected(tab):
	#if tab == 0:
		#update_items()


func search():
	clear_items()
	
	var text = search_text.text
	if not text.begins_with( ":" ):
		search_name( text )
	else:
		if text.begins_with( COMMAND_TAG ):
			search_tags( text )
		elif text.begins_with( COMMAND_TYPE ):
			search_type( text )
		elif text.begins_with( COMMAND_LICENSE ):
			search_license( text )
		# TODO "and" and "or" operators
		else:
			assert( "Only commands start with ':'!" )


func search_name( text : StringName ):
	var new_text : String = text
	new_text = "%" + new_text + "%"
	new_text.replace( " ", "_" )
	append_items( DatabaseManager.search_name( new_text ) )


func search_tags( text : StringName ):
	text = text.trim_prefix( COMMAND_TAG )
	var tags := text.split( " ", false )
	append_items( DatabaseManager.get_items_by_tag( tags ) )


func search_type( text : StringName ):
	text = text.trim_prefix( COMMAND_TYPE )
	append_items( DatabaseManager.get_items_by_type( text ) )


func search_license( text : StringName ):
	text = text.trim_prefix( COMMAND_LICENSE )
	append_items( DatabaseManager.get_items_by_license( text ) )


func _on_search_button_pressed():
	search()


func _on_search_text_text_submitted( text ):
	search()
