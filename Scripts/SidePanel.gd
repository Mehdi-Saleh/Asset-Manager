extends PanelContainer

@export var open_panel_button : Button
@export var main_split_container : SplitContainer


func open_panel():
	show()
	open_panel_button.hide()
	main_split_container.dragger_visibility = SplitContainer.DRAGGER_VISIBLE


func close_panel():
	hide()
	open_panel_button.show()
	main_split_container.dragger_visibility = SplitContainer.DRAGGER_HIDDEN



func _on_close_side_panel_pressed():
	close_panel()


func _on_open_side_panel_pressed():
	open_panel()
