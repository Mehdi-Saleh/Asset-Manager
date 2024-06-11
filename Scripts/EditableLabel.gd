class_name EditableLabel
extends Button


@export_enum( "name", "type", "license" ) var whats_this_for : String = "name"

@onready var text_button : Button = $Edit
@onready var line_edit : LineEdit = $LineEdit

signal change_item( change_what : StringName, new_value : StringName )


func _on_edit_pressed():
	text_button.hide()
	line_edit.show()
	line_edit.text = text
	line_edit.grab_focus()


func _on_line_edit_text_submitted( new_text : StringName ):
	text_button.show()
	text = new_text
	change_item.emit( whats_this_for, new_text )
	line_edit.hide()


func _on_line_edit_focus_exited():
	text_button.show()
	line_edit.hide()


	
