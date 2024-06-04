class_name FileImporter
extends Node

@onready var file_dialog : FileDialog = $FileDialog
#@export var address_text : TextEdit

@export_category( "File Types" )
@export var ignore_formats : PackedStringArray
@export var graphic_2d_formats : PackedStringArray
@export var graphic_3d_formats : PackedStringArray
@export var audio_formats : PackedStringArray
@export var code_text_formats : PackedStringArray
@export var info_text_formats : PackedStringArray

var import_mode : ImportMode
var selected_address : String

signal should_update_items

#var data : Dictionary

func open_file_dialog():
	file_dialog.show()
	
func close_file_dialog():
	file_dialog.hide()
	

func import():
	var root_path := selected_address
	
	# TODO spawn items in some other node
	#[Export] public Node itemParent;
	#[Export] public PackedScene itemScene;
	
	
	match import_mode:
		ImportMode.NEW:
			generate_data_dict( selected_address )
		ImportMode.UPDATE:
			generate_data_dict( selected_address, false)


		#// DirContents(rootPath);
		#
		#// foreach ( string s in itemsDict.Keys )
		#// {
		#// 	itemsDict.Add( s, Instanciate(itemScene, itemParent) );
		#// }
	
	
func generate_data_dict( path : StringName, clear_tables : bool = true, is_sub_generation : bool = false ):
	if clear_tables:
		DatabaseManager.create_tables()
	if not is_sub_generation:
		print( "Importing..." )
	
	var directories : PackedStringArray
	
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
					DatabaseManager.add_asset( file_name, file_type, "NONE", path )
			file_name = dir.get_next()
	else:
		assert("An error occurred when trying to access the path.")
		
	for directory in directories:
		generate_data_dict( path + "/" + directory, false, true )
		
	if not is_sub_generation:
		emit_signal( "should_update_items" )
		print( "Done!" )


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
	

# File dialog

func show_file_dialog( import_mode : ImportMode ):
	self.import_mode = import_mode
	open_file_dialog()

func _on_file_dialog_dir_selected(dir):
	selected_address = dir
	import()


func _on_file_selector_receiver_open_dialog( import_mode : ImportMode ):
	show_file_dialog( import_mode )
	



enum ImportMode {
	NEW,
	UPDATE,
}




