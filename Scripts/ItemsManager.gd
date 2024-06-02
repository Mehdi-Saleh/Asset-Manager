extends Node

@export var item_scene : PackedScene
@export var items_parent : Node

var items_active : Array[Item]
var items_inactive : Array[Item]

# Called when the node enters the scene tree for the first time.
func _ready():
	update_items()

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
	#items_inactive.append_array( items_active )
	items_active.clear()
	print(items_inactive.size())


func update_items():
	clear_items()
	print(items_inactive.size())
	var data := DatabaseManager.get_items_from_to( 0, 200 )
	for row in data:
		instanciate_item( row["name"], row["type"], row["license"], row["location"], row["pic_location"], PackedStringArray() )


func _on_tab_container_tab_selected(tab):
	if tab == 0:
		# TODO clear previous items
		update_items()
		print( "nsauthsnahutnsahuuahstuhansuhauh" )
