class_name FileImporter
extends Node

# TODO change / to \ if on windows

@onready var file_dialog : FileDialog = $FileDialog


@export_category( "Options" )
@export var tags : LineEdit
var extracted_tags : PackedStringArray
@export var license : LineEdit
@export var remove_formats : CheckButton
@export var replace_from : LineEdit
@export var replace_to : LineEdit
@export var replace : CheckButton


@export_category( "File Types" )
@export var ignore_formats : PackedStringArray
@export var graphic_2d_formats : PackedStringArray
@export var graphic_3d_formats : PackedStringArray
@export var audio_formats : PackedStringArray
@export var code_text_formats : PackedStringArray
@export var info_text_formats : PackedStringArray


var import_mode : ImportMode ## New clears all the tables before importing but Updates does not clear anything.
var _selected_address : String

#signal should_update_items ## Emitted after importing data as the browse tab needs to be updated then.


func _ready():
	SignalBus.file_importer = self


## Opens the file dialog for selecting a directory.
func _open_file_dialog():
	file_dialog.show()
	

## Closes the file dialog.
func _close_file_dialog():
	file_dialog.hide()
	

## Imports all data in the chosen directory in respect to import_mode.
func import():
	var root_path := _selected_address
	
	match import_mode:
		ImportMode.NEW:
			generate_data_dict( _selected_address, true )
		ImportMode.UPDATE:
			generate_data_dict( _selected_address, false)


## Adds assets in the given path to the database. Clears all tables if clear_tables is set to true.
func generate_data_dict( path : StringName, clear_tables : bool = false, _is_sub_generation : bool = false ):
	if clear_tables:
		DatabaseManager.create_tables()
	if not _is_sub_generation:
		print( "Importing..." )
		if not tags.text.is_empty():
			extracted_tags = tags.text.split( " ", false )
	
	# TODO consider options as well (add tags to all, etc.).
	
	var directories : PackedStringArray # Array of every sub-directory that needs to be scanned as well
	
	var text : String = ""

	var dir := DirAccess.open(path)
	if dir != null:
		dir.list_dir_begin()
		var file_name : String = dir.get_next();
		while file_name != "":
			if dir.current_is_dir():
				directories.append( file_name )
			else:
				text += "-->" + file_name + "\n"
				var file_type : StringName = get_file_type( file_name )
				if file_type != "IGNORE":
					var license_str := "NONE"
					if not license.text.is_empty():
						license_str = license.text
					if extracted_tags.is_empty():
						DatabaseManager.add_asset( file_name, file_type, license_str, path )
					else:
						DatabaseManager.add_asset( file_name, file_type, license_str, path, extracted_tags )
			file_name = dir.get_next()
	else:
		assert("An error occurred when trying to access the path.")
		
	# Extract data from the sub-directories
	for directory in directories:
		generate_data_dict( path + "/" + directory, false, true )
		
	if not _is_sub_generation:
		SignalBus.receive_signal( "show_all_items" )
		print( "Done!" )


# TODO read types from a json file
## Returns the file type of a given file name based on the file format.
func get_file_type( file_name : StringName ) -> StringName:
	var format : String
	if file_name.find( "." ) == -1:
		format = ""
	else:
		format = file_name.get_slice( ".", file_name.get_slice_count( "." ) - 1 )

	if format in ignore_formats:
		return "IGNORE"
	elif format in audio_formats:
		return "Audio"
	elif format in code_text_formats:
		return "Code"
	elif format in info_text_formats:
		return "Text"
	elif format in graphic_2d_formats:
		return "Graphic2D"
	elif format in graphic_3d_formats:
		return "Graphic3D"
	else:
		return "NONE"
	

# **File dialog**
## Opens the file dialog and sets the import_mode.
func show_file_dialog( import_mode : ImportMode ):
	self.import_mode = import_mode
	_open_file_dialog()

#
func _on_file_dialog_dir_selected(dir):
	_selected_address = dir
	import()



## All possible import modes
enum ImportMode {
	NEW,
	UPDATE,
}




