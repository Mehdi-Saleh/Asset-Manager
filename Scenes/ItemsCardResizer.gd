class_name ItemsCardResizer
extends GridContainer

@export var item_min_width : float = 330
@export var item_max_width : float = 400

var _viewport : Viewport

# Called when the node enters the scene tree for the first time.
func _ready():
	_viewport = get_viewport()
	_viewport.size_changed.connect( resize_items )
	resize_items()
	SignalBus.items_card_resizer = self


func resize_items() -> void:
	print( "update!" )
	var size := get_rect().size
	var columns_floor :float = size.x / item_max_width
	var columns_ceiling :float = size.x / item_min_width
	
	if columns < columns_floor or columns > columns_ceiling:
		columns = columns_ceiling
