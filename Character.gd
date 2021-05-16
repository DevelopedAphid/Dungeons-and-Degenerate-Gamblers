extends Sprite

var move_step: int
var tween: Tween
var is_moving: bool

func _ready():
	move_step = get_parent().grid_size
	tween = get_node("Tween")
	is_moving = false

func _process(_delta):
	if Input.is_action_just_released("ui_right") and not is_moving:
		is_moving = true
		tween.interpolate_property(self, "position",
			position, position + Vector2(move_step,0),
			1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
	if Input.is_action_just_released("ui_left") and not is_moving:
		is_moving = true
		tween.interpolate_property(self, "position",
			position, position + Vector2(-move_step,0),
			1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
	if Input.is_action_just_released("ui_down") and not is_moving:
		is_moving = true
		tween.interpolate_property(self, "position",
			position, position + Vector2(0,move_step),
			1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
	if Input.is_action_just_released("ui_up") and not is_moving:
		is_moving = true
		tween.interpolate_property(self, "position",
			position, position + Vector2(0,-move_step),
			1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
	if Input.is_action_just_pressed("click") and not is_moving:
		is_moving = true
		tween.interpolate_property(self, "position",
			position, get_parent().snap_vector_to_grid(get_global_mouse_position()),
			1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()


func _on_Tween_tween_all_completed():
	is_moving = false
