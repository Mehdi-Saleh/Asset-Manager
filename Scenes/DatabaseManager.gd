extends Node


const MAIN_TABLE_NAME : StringName = "Main"
var main_table_template := {
	"id" : { "data_type":"int", "primary_key":true, "not_null":true, "auto_increment":true },
	"name" : { "data_type":"text", "not_null":true,  },
	"location" : { "data_type":"text", "not_null":true,  },
	"pic_location" : { "data_type":"text",  },
	"type" : { "data_type":"text", "not_null":true,  },
	"license" : { "data_type":"text", "not_null":true,  },
}


@export var database_path : StringName = "res://database.db"

var database : SQLite

func _ready():
	init()
	
	#add_asset("anutsh", "aotnuehs", "theo", "ouuo")


# Initializes the database on start
func init():
	database = SQLite.new()
	database.path = database_path
	database.open_db()
	
	create_tables()
	
	#database.close_db()

func create_tables():
	database.delete_rows(MAIN_TABLE_NAME, "true")
	# Main table
	database.create_table( MAIN_TABLE_NAME, main_table_template)
	
	# Tags table
	
	# Main <-> Tags table
	

func add_asset( name:String, type:String, license:String, location:String, pic_location:String = "DEFAULT" ):
	var data : Dictionary = {
		"name" : name,
		"type" : type,
		"license" : license,
		"location" : location,
		"pic_location" : pic_location,
	}
	database.insert_row( MAIN_TABLE_NAME, data )
	

# TODO
func remove_asset( location:StringName ):
	pass















