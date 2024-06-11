class_name TagItem
extends Button


@onready var remove : Button = $Remove

@export var hide_remove_delay : float = 10.0

var timer : Timer = Timer.new()


func _ready():
	timer.autostart = false
	timer.one_shot = true
	timer.wait_time = hide_remove_delay
	timer.timeout.connect( _on_timer_timeout )
	add_child( timer )


func set_tag( tag : StringName ):
	text = tag


func _on_pressed():
	SignalBus.receive_signal( "search_tags", { "tags" : [ text, ] } )


func _on_mouse_entered():
	remove.show()


func _on_mouse_exited():
	timer.start()


func _on_timer_timeout():
	print( "ausht" )
	remove.hide()
