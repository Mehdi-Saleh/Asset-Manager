class_name TagItem
extends Button


func set_tag( tag : StringName ):
	text = tag


func _on_pressed():
	SignalBus.receive_signal( "search_tags", { "tags" : [ text, ] } )
