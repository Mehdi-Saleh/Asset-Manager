extends Node


const MAIN_TABLE_NAME : StringName = "Main"
const TAGS_TABLE_NAME : StringName = "Tags"
const MAIN_TAGS_TABLE_NAME : StringName = "Main_Tags"
const NEW_TABLE_NAME : StringName = "New"

var main_table_template := {
	"id" : { "data_type":"int", "primary_key":true, "not_null":true, "auto_increment":true },
	"name" : { "data_type":"text", "not_null":true,  },
	"real_name" : { "data_type":"text", "not_null":true,  },
	"location" : { "data_type":"text", "not_null":true,  },
	"pic_location" : { "data_type":"text",  },
	"type" : { "data_type":"text", "not_null":true,  },
	"license" : { "data_type":"text", "not_null":true,  },
}
var tags_table_template := {
	"id" : { "data_type":"int", "primary_key":true, "not_null":true, "auto_increment":true },
	"tag" : { "data_type":"text", "not_null":true,  },
}
var main_tags_table_template := {
	"id" : { "data_type":"int", "primary_key":true, "not_null":true, "auto_increment":true },
	"id_main" : { "data_type":"int", "not_null":true,  },
	"id_tag" : { "data_type":"int", "not_null":true,  },
}
var new_table_template := {
	"id" : { "data_type":"int", "primary_key":true, "not_null":true },
}


@export var database_path : StringName = "res://database.db"

var database : SQLite

func _ready():
	init()
	
	var t := get_items_by_id( get_ids_by_tag( [ "Cool", ]) )
	for i in t:
		print( i[ "name" ] )
	
	#add_asset("anutsh", "aotnuehs", "theo", "ouuo")


# Initializes the database on start
func init():
	database = SQLite.new()
	database.path = database_path
	database.open_db()


func create_tables():
	# Main table
	database.drop_table( MAIN_TABLE_NAME )
	database.create_table( MAIN_TABLE_NAME, main_table_template)
	
	# Tags table
	database.drop_table( TAGS_TABLE_NAME )
	database.create_table( TAGS_TABLE_NAME, tags_table_template)
	# Main <-> Tags table
	database.drop_table( MAIN_TAGS_TABLE_NAME )
	database.create_table( MAIN_TAGS_TABLE_NAME, main_tags_table_template)
	# New enteries table
	database.drop_table( NEW_TABLE_NAME )
	database.create_table( NEW_TABLE_NAME, new_table_template)

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
	
	#var id : int = get_item_id( name )
	#for tag in tags:
			#add_tag( tag, id )
	
	
func add_tag( tag:StringName, id_main:int ):
	#pass
	database.query( "SELECT id FROM " + TAGS_TABLE_NAME + " WHERE tag=\"" + tag + "\";" )
	if database.query_result.size() == 0:
		database.insert_row( TAGS_TABLE_NAME, { "tag":str(tag) } )
		database.query( "SELECT id FROM " + TAGS_TABLE_NAME + " WHERE tag=\"" + tag + "\";" )
	
	var id_tag : int = database.query_result[0] [ "id" ]
	database.insert_row( MAIN_TAGS_TABLE_NAME, { "id_main" : id_main, "id_tag" : id_tag })


# TODO
func remove_asset( location:StringName ):
	pass


#func update_items():
	#$ItemsManager.update_items()


func get_items_all() -> Array[Dictionary]:
	database.query( "SELECT * FROM " + MAIN_TABLE_NAME + ";" )
	return database.query_result
	

func get_ids_by_tag( tags : PackedStringArray ) -> PackedInt32Array:
	var array_string := array_to_sql_list( str( tags ) )
	
	database.query( 
		"SELECT id_main 
		FROM " + MAIN_TAGS_TABLE_NAME + " JOIN " + TAGS_TABLE_NAME + 
		" ON " + MAIN_TAGS_TABLE_NAME + ".id_tag = " + TAGS_TABLE_NAME + ".id 
		WHERE tag IN " + array_string + ";" )
	
	var ids : PackedInt32Array
	for id in database.query_result:
		ids.append( id[ "id_main" ] )
	
	return ids
	
func get_items_by_id( ids : PackedInt32Array ) -> Array[Dictionary]:
	print( ids )
	var array_string := array_to_sql_list( str( ids ) )
	database.query( " SELECT * FROM " + MAIN_TABLE_NAME + " WHERE id IN" + array_string + ";")
	return database.query_result

func get_items_by_tag( tags : PackedStringArray ) -> Array[Dictionary]:
	return get_items_by_id( get_ids_by_tag( tags ) )

func get_items_from_to( from:int, to:int ) -> Array[Dictionary]:
	database.query( "SELECT * FROM " + MAIN_TABLE_NAME + " WHERE id>=" + str(from) + " AND id<" + str(to) + ";" )
	return database.query_result
	
	
func get_item_id( real_name:StringName ):
	database.query( "SELECT id FROM " + MAIN_TABLE_NAME + " WHERE real_name=\"" + real_name + "\";" )
	return database.query_result.front()[ "id" ]


func array_to_sql_list( array_string : String ) -> String:
	array_string = array_string.replace( "[", "(" )
	array_string = array_string.replace( "]", ")" )
	return array_string
