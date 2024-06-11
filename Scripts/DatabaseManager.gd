extends Node


# Table names
const MAIN_TABLE_NAME : StringName = "Main"
const TAGS_TABLE_NAME : StringName = "Tags"
const MAIN_TAGS_TABLE_NAME : StringName = "Main_Tags"
const NOTES_TABLE_NAME : StringName = "Notes"
const NEW_TABLE_NAME : StringName = "New"

# Table templates (tables are created according to these when creating a new database)
var main_table_template := {
	"id" : { "data_type":"int", "primary_key":true, "not_null":true, "auto_increment":true },
	"name" : { "data_type":"text", "not_null":true,  },
	"real_name" : { "data_type":"text", "not_null":true,  },
	"location" : { "data_type":"text", "not_null":true,  },
	"pic_location" : { "data_type":"text",  },
	"type" : { "data_type":"text", "not_null":true,  },
	"license" : { "data_type":"text", "not_null":true,  },
}
# TODO info table
var tags_table_template := {
	"id" : { "data_type":"int", "primary_key":true, "not_null":true, "auto_increment":true },
	"tag" : { "data_type":"text", "not_null":true,  },
}
var main_tags_table_template := {
	"id" : { "data_type":"int", "primary_key":true, "not_null":true, "auto_increment":true },
	"id_main" : { "data_type":"int", "not_null":true,  },
	"id_tag" : { "data_type":"int", "not_null":true,  },
}
var notes_table_template := {
	"id" : { "data_type":"int", "primary_key":true, "not_null":true, "auto_increment":true },
	"id_main" : { "data_type":"int", "not_null":true,  },
	"note" : { "data_type":"text", "not_null":true,  },
}
var new_table_template := {
	"id" : { "data_type":"int", "primary_key":true, "not_null":true },
}


@export var database_path : StringName = "res://database.db"

var database : SQLite

func _ready():
	init()


## Initializes the database on launch.
func init():
	database = SQLite.new()
	database.path = database_path
	database.open_db()


## (re)Creates all tables in the database. IMPORTANT: this will erase any pre-existing data!!
func create_tables():
	# Main table
	database.drop_table( MAIN_TABLE_NAME )
	database.create_table( MAIN_TABLE_NAME, main_table_template )
	
	# Tags table
	database.drop_table( TAGS_TABLE_NAME )
	database.create_table( TAGS_TABLE_NAME, tags_table_template )
	
	# Main <-> Tags table
	database.drop_table( MAIN_TAGS_TABLE_NAME )
	database.create_table( MAIN_TAGS_TABLE_NAME, main_tags_table_template )
	
	# TODO
	# Notes table
	database.drop_table( NOTES_TABLE_NAME )
	database.create_table( NOTES_TABLE_NAME, notes_table_template )
	
	# TODO
	# New enteries table
	database.drop_table( NEW_TABLE_NAME )
	database.create_table( NEW_TABLE_NAME, new_table_template )

## Adds a new asset to the database if it doesn't already exist there.
func add_asset( name:String, real_name:String, type:String, license:String, location:String, tags:PackedStringArray=PackedStringArray(), pic_location:String = "DEFAULT" ):
	var data : Dictionary = {
		"name" : name,
		"real_name" : real_name,
		"type" : type,
		"license" : license,
		"location" : location,
		"pic_location" : pic_location,
	}
	
	# Don't add item if it already exists
	database.query( " Select id FROM " + MAIN_TABLE_NAME + " WHERE real_name=\"" + name + "\" AND location=\"" + location + "\" ;" )
	if not database.query_result.size() > 0:
		database.insert_row( MAIN_TABLE_NAME, data )
	
	if not tags.is_empty():
		database.query( " Select id FROM " + MAIN_TABLE_NAME + " WHERE real_name=\"" + name + "\" AND location=\"" + location + "\" ;" )
		var id : int = database.query_result.front()[ "id" ]
		add_tags( tags, id )
	
	# TODO
	#var id : int = get_item_id( name )
	#for tag in tags:
			#add_tag( tag, id )


## Adds a tag to an already existing item.
func add_tag( tag:StringName, item_id:int ):
	# TODO do not add repeated tags
	database.query( "SELECT id FROM " + TAGS_TABLE_NAME + " WHERE tag=\"" + tag + "\";" )
	if database.query_result.size() == 0:
		database.insert_row( TAGS_TABLE_NAME, { "tag":str(tag) } )
		database.query( "SELECT id FROM " + TAGS_TABLE_NAME + " WHERE tag=\"" + tag + "\";" )
	
	var tag_id : int = database.query_result[0] [ "id" ]
	database.insert_row( MAIN_TAGS_TABLE_NAME, { "id_main" : item_id, "id_tag" : tag_id })


## Adds the given tags to the item
func add_tags( tags:PackedStringArray, item_id:int ):
	for tag in tags:
		add_tag( tag, item_id )


# TODO Removes an asset from the database
func remove_asset( location:StringName ):
	pass

# TODO func to update an item
func update_item( id:int, values:Dictionary ):
	database.update_rows( MAIN_TABLE_NAME, "id = " + str( id ) + ";", values )

## Returns every item in the database. 
## It is not recommended to use this often as the number of items
## could easily reach beyound thousands!
func get_items_all() -> Array[Dictionary]:
	database.query( "SELECT * FROM " + MAIN_TABLE_NAME + ";" )
	return database.query_result
	

## Returns id of every item that has one or more of the given tags.
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
	

## Returns id of every item that has one or more of the given tags.
func get_tags_by_id( id : int ) -> PackedStringArray:
	database.query( 
		"SELECT tag 
		FROM " + MAIN_TAGS_TABLE_NAME + " JOIN " + TAGS_TABLE_NAME + 
		" ON " + MAIN_TAGS_TABLE_NAME + ".id_tag = " + TAGS_TABLE_NAME + ".id 
		WHERE id_main = " + str( id ) + ";" )
	
	var tags := database.query_result
	var tags_new : PackedStringArray
	for tag in tags:
		tags_new.append( tag[ "tag" ])
	
	return tags_new


## Returns items using the given ids.
func get_items_by_id( ids : PackedInt32Array ) -> Array[Dictionary]:
	var array_string := array_to_sql_list( str( ids ) )
	database.query( " SELECT * FROM " + MAIN_TABLE_NAME + " WHERE id IN" + array_string + ";")
	return database.query_result


## Returns the item using the given id.
func get_item_by_id( id : int ) -> Dictionary:
	database.query( " SELECT * FROM " + MAIN_TABLE_NAME + " WHERE id =" + str( id ) + ";")
	return database.query_result.front()


## Returns items with the given type
func get_items_by_type( type : StringName ) -> Array[ Dictionary ]:
	database.query( " SELECT * FROM " + MAIN_TABLE_NAME + " WHERE type = \"" + type + "\";")
	return database.query_result


## Returns items with the given license
func get_items_by_license( license : StringName ) -> Array[ Dictionary ]:
	database.query( " SELECT * FROM " + MAIN_TABLE_NAME + " WHERE license = \"" + license + "\";")
	return database.query_result


## Returns every item that has one or more of the given tags
func get_items_by_tag( tags : PackedStringArray ) -> Array[Dictionary]:
	return get_items_by_id( get_ids_by_tag( tags ) )
	

## Searches the database for names that are close to the given name
func search_name( name : StringName ) -> Array[Dictionary]:
	database.query( " SELECT * FROM " + MAIN_TABLE_NAME + " WHERE name LIKE \"" + name + "\";")
	return database.query_result


## Returns every item with an id between from (inclusive) and to (exclusive).
func get_items_from_to( from:int, to:int ) -> Array[Dictionary]:
	database.query( "SELECT * FROM " + MAIN_TABLE_NAME + " WHERE id>=" + str(from) + " AND id<" + str(to) + ";" )
	return database.query_result
	

## Returns id of a single item using the item's real_name.
## (It is possible to pass the item's location as well for ensuring correct results.)
func get_item_id( real_name:StringName ):
	database.query( "SELECT id FROM " + MAIN_TABLE_NAME + " WHERE real_name=\"" + real_name + "\";" )
	return database.query_result.front()[ "id" ]


## Gets an array in string format ("[ item1, item2, ... ]") and returns
## the same array in a format that is readable by SQL ("( item1, item2, ... )")
func array_to_sql_list( array_string : String ) -> String:
	array_string = array_string.replace( "[", "(" )
	array_string = array_string.replace( "]", ")" )
	return array_string
