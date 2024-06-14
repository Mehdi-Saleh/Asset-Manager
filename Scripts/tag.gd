class_name TagItem
extends Button


const EXTRA_SPACE_ON_HOVER := "    "

@onready var remove : Button = $Remove

@export var hide_remove_delay : float = 0.1
@export var show_remove_button : bool = true

var timer : Timer = Timer.new()
var tag : String
var can_hide_remove : bool = true
var is_mouse_on_tag : bool = false


func _ready():
	timer.autostart = false
	timer.one_shot = true
	timer.wait_time = hide_remove_delay
	timer.timeout.connect( _on_timer_timeout )
	add_child( timer )


func set_tag( tag : StringName ):
	self.tag = tag
	text = tag


func _on_pressed():
	SignalBus.receive_signal( "search_tags", { "tags" : [ text, ] } )


func _on_mouse_entered():
	if show_remove_button:
		is_mouse_on_tag = true
		text = tag + EXTRA_SPACE_ON_HOVER
		remove.show()


func _on_mouse_exited():
	if show_remove_button:
		is_mouse_on_tag = false
		timer.start()


func _on_timer_timeout():
	if can_hide_remove and not is_mouse_on_tag:
		text = tag
		remove.hide()


func _on_remove_mouse_entered():
	if show_remove_button:
		can_hide_remove = false


func _on_remove_mouse_exited():
	if show_remove_button:
		can_hide_remove = true
	timer.start()
