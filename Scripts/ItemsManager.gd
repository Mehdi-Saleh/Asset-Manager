extends Node

@export var items : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(items[0]).initialize( "file_name", "type:St", "lic", "location:StringName", "pic_location:StringName", Array())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
