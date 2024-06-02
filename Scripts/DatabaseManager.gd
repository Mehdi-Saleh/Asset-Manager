extends Node


const MAIN_TABLE_NAME : StringName = "Main"
var main_table_template := {
	"id" : { "data_type":"int", "primary_key":true, "not_null":true, "auto_increment":true },
	"name" : { "data_type":"text", "not_null":true,  },
	"real_name" : { "data_type":"text", "not_null":true,  },
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
	
	#create_tables()
	
	#database.close_db()

func create_tables():
	# Main table
	#database.delete_rows(MAIN_TABLE_NAME, "true")
	database.drop_table( MAIN_TABLE_NAME )
	database.create_table( MAIN_TABLE_NAME, main_table_template)
	
	# TODO Tags table
	
	# TODO Main <-> Tags table
	
	# TODO New enteries table
	

func add_asset( name:String, type:String, license:String, location:String, pic_location:String = "DEFAULT" ):
	#print( name )
	var data : Dictionary = {
		"name" : name, # TODO add custom names
		"real_name" : name,
		"type" : type,
		"license" : license,
		"location" : location,
		"pic_location" : pic_location,
	}
	database.insert_row( MAIN_TABLE_NAME, data )
	

# TODO
func remove_asset( location:StringName ):
	pass


#func update_items():
	#$ItemsManager.update_items()


func get_items_all() -> Array[Dictionary]:
	database.query( "SELECT * FROM " + MAIN_TABLE_NAME + ";" )
	return database.query_result


func get_items_from_to( from:int, to:int ) -> Array[Dictionary]:
	database.query( "SELECT * FROM " + MAIN_TABLE_NAME + " WHERE id>=" + str(from) + " AND id<" + str(to) + ";" )
	return database.query_result















