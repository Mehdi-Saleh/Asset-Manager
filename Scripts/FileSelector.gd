class_name FileSelector
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
			pass
		ImportMode.ADD:
			pass

		#// DirContents(rootPath);
		#
		#// foreach ( string s in itemsDict.Keys )
		#// {
		#// 	itemsDict.Add( s, Instanciate(itemScene, itemParent) );
		#// }
	
	
func generate_data_dict( path : StringName, clear_tables : bool = true ):
	if clear_tables:
		DatabaseManager.create_tables()
	
	var directories : PackedStringArray
	
	var text : String = ""
	#using var dir = DirAccess.Open(path);
	var dir := DirAccess.open(path)
	if dir != null:
		dir.list_dir_begin()
		var file_name : String = dir.get_next();
		while file_name != "":
			if dir.current_is_dir():
				#print( "directory --> " + file_name + "\n" )
				directories.append( file_name )
			else:
				#print( "-->" + file_name + "\n" )
				text += "-->" + file_name + "\n"
				#data[file_name] = Item.new()
				var file_type : StringName = get_file_type( file_name )
				#if file_type != "IGNORE":
				DatabaseManager.add_asset( file_name, file_type, "NONE", path )
			file_name = dir.get_next()
	#else:
		#print("An error occurred when trying to access the path.")
		
		
	#print( "****************\n" )
	for directory in directories:
		generate_data_dict( path + "/" + directory, false )


func get_file_type( file_name : StringName ) -> StringName:
	var format : String = file_name.get_slice( ".", file_name.get_slice_count( "." ) - 1 )
	#print( format )
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
	

	
#func set_address( dir:StringName ):
	#selected_address = dir

#
#func _on_choose_dir_button_pressed():
	#open_file_dialog()


# Buttons

#func _on_generate_new_button_pressed():
	#import_mode = ImportMode.NEW
	#open_file_dialog()
	##file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_DIR
#
#
#func _on_update_button_pressed():
	#import_mode = ImportMode.UPDATE
	#open_file_dialog()
#
#
#func _on_import_button_pressed():
	#import_mode = ImportMode.ADD
	#open_file_dialog()

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
	ADD
}




