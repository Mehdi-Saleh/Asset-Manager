extends Node

# All references will be set by the objects themselves. Do not set manually.
var file_importer : FileImporter
var items_manager : ItemsManager
var side_panel : SidePanel



func receive_signal( signal_name : StringName, arguements : Dictionary = Dictionary() ):
	match signal_name:
		# Items
		"show_all_items":
			# TODO should change later
			items_manager.update_items( DatabaseManager.get_items_all() )
		"search_tags":
			var new_search_text : String = items_manager.COMMAND_TAG
			for tag in arguements[ "tags" ]:
				new_search_text += tag
			items_manager.search_text.text = new_search_text
			items_manager.update_items( DatabaseManager.get_items_by_tag( arguements[ "tags" ] ) )
		"show_items":
			items_manager.update_items( arguements[ "items" ] )
			if arguements.has( "new_search_text" ):
				items_manager.search_text.text = arguements[ "new_search_text" ]
		"reload_items":
			items_manager.reload_items( DatabaseManager.redo_search() )
		"reinitialize_item":
			items_manager.reinitialize_item( arguements["item_id"] )
		"select_item":
			items_manager.select_item( arguements["item_id"] )
		"deselect_item":
			items_manager.deselect_item( arguements["item_id"] )
		
		# Side Panel
		"open_side_panel":
			items_manager.set_should_update()
			side_panel.open_panel()
		"close_side_panel":
			items_manager.set_should_update()
			side_panel.close_panel()
		"show_in_side_panel":
			items_manager.set_should_update()
			side_panel.show_item( arguements[ "id" ] )
		"add_tag_side_panel":
			var item_id : int = side_panel.get_current_item_id()
			DatabaseManager.add_tag( arguements[ "tag" ], item_id )
			side_panel.show_item( side_panel.get_current_item_id() )
			#items_manager.reinitialize_item( item_id )
			
		# Import Tab
		"generate_new_database":
			file_importer.show_file_dialog( FileImporter.ImportMode.NEW )
		"update_database":
			file_importer.show_file_dialog( FileImporter.ImportMode.UPDATE )
		
		# Default
		_:
			assert( "No such signal is available: " + signal_name )
