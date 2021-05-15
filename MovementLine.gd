extends Line2D

var character: Sprite

func _ready():
	character = get_parent().get_node("Character")
	add_point(character.global_position)
	add_point(character.global_position)
	print(character.global_position)


func _on_Tween_tween_started(object, key):
	points[0] = character.global_position


func _on_Tween_tween_step(object, key, elapsed, value):
	points[1] = character.global_position
