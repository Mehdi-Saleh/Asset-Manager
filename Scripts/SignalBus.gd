extends Node

# All references will be set by the objects themselves. Do not set manually.
var file_importer : FileImporter
var items_manager : ItemsManager
var side_panel : SidePanel



func receive_signal( signal_name : StringName, arguements : Array = Array() ):
	match signal_name:
		# Items
		"show_all_items":
			# TODO should change later
			items_manager.update_items( DatabaseManager.get_items_from_to( 0, 200 ) )
		
		# Side Panel
		"open_side_panel":
			side_panel.open_panel()
		"close_side_panel":
			side_panel.close_panel()
		"show_in_side_panel":
			side_panel.show_item( arguements[ 0 ] )
			
		# Import Tab
		"generate_new_database":
			file_importer.show_file_dialog( FileImporter.ImportMode.NEW )
		"update_database":
			file_importer.show_file_dialog( FileImporter.ImportMode.UPDATE )
