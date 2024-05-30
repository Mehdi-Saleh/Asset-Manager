extends Node

@export var file_dialog : FileDialog
@export var address_text : TextEdit



func open_file_dialog():
	file_dialog.show()
	
func close_file_dialog():
	file_dialog.hide()
	
func set_address_text( dir:StringName ):
	address_text.text = dir


func _on_choose_dir_button_pressed():
	open_file_dialog()


func _on_file_dialog_dir_selected(dir):
	set_address_text( dir )


func _on_file_dialog_file_selected(path):
	set_address_text( path )
