extends Node

var slash_sign : String


func _ready():
	if OS.get_distribution_name() == "Windows":
		slash_sign = "\\"
	else:
		slash_sign = "/"
