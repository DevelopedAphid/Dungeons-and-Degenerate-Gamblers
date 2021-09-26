extends Node2D

func _ready():
	pass # Replace with function body.

func will_hit() -> bool:
	if get_parent().score < 17:
		return true
	else:
		return false
