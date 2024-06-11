class_name ItemsManager
extends Node

const COMMAND_TAG := ":tag "
const COMMAND_TYPE := ":type "
const COMMAND_LICENSE := ":license "

const NUM_OF_ITEMS_TO_LOAD := 100
const LOAD_MORE_ON_SCROLL_VALUE := 0.9

@export var item_scene : PackedScene
@export var items_parent : FlowContainer
@export var items_scroll_container : ScrollContainer
@export var search_text : LineEdit

var items_active : Array[Item]
var items_inactive : Array[Item]

var last_query : Array[Dictionary]
var last_loaded_from_query : int = -1
var scroll_value : float = 0.0 # 0.0 to 1.0
var last_line_count : int = 0


func _ready():
	SignalBus.items_manager = self
	get_window().size_changed.connect( update_scroll_relative )
	
	SignalBus.receive_signal( "show_all_items" )


func _process(delta):
	if Input.is_action_just_released( "update_scroll" ):
		_on_scroll_container_scroll_ended()


## Instanciates a new item object with the given values. (Objects are pooled.)
func instanciate_item( item_id:int, name:StringName, file_name:StringName, type:StringName, license:StringName, location:StringName, pic_location ) -> Item:
	# Create a new item object if none are available
	if items_inactive.is_empty():
		items_inactive.append( item_scene.instantiate() )
		items_parent.add_child( items_inactive.back() )
	
	var new_item : Item = items_inactive.pop_back()
		
	# Initialize the item
	new_item.initialize( item_id, name, file_name, type, license, location, pic_location )
	new_item.show()
	items_active.append( new_item )
	return new_item


## Disables the given item objects and adds it back to the pool.
func remove_item( item : Item ):
	items_active.remove_at( item.item_id )
	items_inactive.append( item )
	item.hide()


## Instanciates more items. Used to prevent instanciating everything at once! 
## Returns true if any items were actually instanciated
func _load_more_items() -> bool:
	var query_size := last_query.size()
	if query_size >= last_loaded_from_query:
		var target_load : int = last_loaded_from_query + NUM_OF_ITEMS_TO_LOAD
		if target_load >= query_size:
			target_load = query_size - 1
		for item in last_query.slice( last_loaded_from_query+1, target_load+1 ):
			instanciate_item( item[ "id" ], item[ "name" ], item[ "real_name" ], item[ "type" ], item[ "license" ], item[ "location" ], item[ "pic_location" ] )
		last_loaded_from_query = target_load
		return true
	else:
		return false
	
	last_line_count = items_parent.get_line_count()


## Disables all active item objects and adds them back to the pool.
func clear_items():
	last_query.clear()
	last_loaded_from_query = -1
	for i in range( items_active.size()-1, -1, -1):
		items_active[i].hide()
		items_inactive.append( items_active[i] )
	items_active.clear()


## Instanciates item objects but does not clear previous ones.
func append_items( items : Array[Dictionary], load_items : bool = true ):
	last_query.append_array( items )
	if load_items:
		_load_more_items()


## Clears and re-instanciates all item objects.
func update_items( items : Array[Dictionary] ):
	clear_items()
	append_items( items, false )
	last_loaded_from_query = -1
	_load_more_items()


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


func get_scroll_value() -> float:
	var max_scroll_value : float = max( 0.0, float( items_parent.get_rect().size.y - items_scroll_container.get_rect().size.y ))
	scroll_value = float( items_scroll_container.scroll_vertical ) / max_scroll_value
	return scroll_value


func set_scroll_value( value : float ) -> void:
	var max_scroll_value : float = max( 0.0, float( items_parent.get_rect().size.y - items_scroll_container.get_rect().size.y ))
	items_scroll_container.scroll_vertical = int( value * max_scroll_value )


## Change scroll value an container size change to always stay on the same item.
func update_scroll_relative():
	var line_count := items_parent.get_line_count()
	if last_line_count != 0 and last_line_count != line_count:
		set_scroll_value( get_scroll_value() * float( last_line_count) / float( line_count ) )
	last_line_count = line_count


func set_last_line_count():
	last_line_count = items_parent.get_line_count()


func _on_search_button_pressed():
	search()


func _on_search_text_text_submitted( text ):
	search()


func _on_scroll_container_scroll_ended():
	if get_scroll_value() >= LOAD_MORE_ON_SCROLL_VALUE:
		_load_more_items()
