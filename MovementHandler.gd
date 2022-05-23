extends Node2D

signal movement_completed(card)

var card_move_duration = 0.25
onready var card = get_parent()
var is_moving

func move_card_to(to_position: Vector2):
	$PositionTween.interpolate_property(card, "position", card.position, to_position, card_move_duration, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	$PositionTween.start()

func _physics_process(_delta):
	if is_moving:
		#make it so movement is pixel perfect
		card.position.x = round(card.position.x)
		card.position.y = round(card.position.y)

func _on_PositionTween_tween_started(_object, _key):
	is_moving = true

func _on_PositionTween_tween_completed(_object, _key):
	is_moving = false
	emit_signal("movement_completed", card)
