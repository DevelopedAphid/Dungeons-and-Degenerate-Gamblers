extends Line2D

var character: Sprite

func _ready():
	character = get_parent().get_node("Character")
	visible = false


#no idea why the global positions need 2* but they do
#alsoe refactor to use signals to do the tweening/character movement?

func _on_Tween_tween_started(object, key):
	points[0] = 2*object.get_parent().snap_vector_to_grid(get_global_mouse_position())
	visible = true


func _on_Tween_tween_step(object, key, elapsed, value):
	points[1] = 2*character.global_position


func _on_Tween_tween_all_completed():
	visible = false
