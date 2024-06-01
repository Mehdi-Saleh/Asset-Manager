extends Node

@export var item_scene : PackedScene
@export var items_parent : Node

var items_active : Array[Item]
var items_inactive : Array[Item]

# Called when the node enters the scene tree for the first time.
func _ready():
	update_items()

func instanciate_item( file_name:StringName, type:StringName, license:StringName, location:StringName, pic_location, tags:PackedStringArray ) -> Item:
	var new_item : Item = item_scene.instantiate()
	items_parent.add_child( new_item )
	new_item.initialize( file_name, type, license, location, pic_location, tags )
	items_active.append( new_item )
	return new_item


func update_items():
	var data := DatabaseManager.get_items_from_to( 0, 200 )
	for row in data:
		instanciate_item( row["name"], row["type"], row["license"], row["location"], row["pic_location"], PackedStringArray() )
