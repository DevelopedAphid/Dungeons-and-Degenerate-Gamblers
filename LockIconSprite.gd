extends Sprite

var is_moving = false

func _physics_process(_delta):
	if is_moving:
		#make it so movement is pixel perfect
		position.x = round(position.x)
		position.y = round(position.y)

func _on_PositionTween_tween_all_completed():
	is_moving = false
