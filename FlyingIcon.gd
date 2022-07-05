extends Sprite

var target_position: Vector2
var movement_duration = 0.6

func _ready():
	hframes = 4
	vframes = 1

func _physics_process(_delta):
	position.x = round(position.x)
	position.y = round(position.y)

func set_target_position(target_pos: Vector2):
	target_position = target_pos

func start_tweening_to_target():
	$PositionTween.interpolate_property(self, "position", position, target_position, movement_duration)
	$PositionTween.start()

func set_icon(icon_type: String):
	match icon_type:
		"spades":
			frame = 0
		"clubs":
			frame = 1
		"diamonds":
			frame = 2
		"hearts":
			frame = 3

func _on_PositionTween_tween_all_completed():
	queue_free()
