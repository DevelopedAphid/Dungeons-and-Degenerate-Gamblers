extends Node2D

var cursor_point = load("res://assets/art/cursor1.png")
var cursor_hit = load("res://assets/art/cursor2.png")
var cursor_stand = load("res://assets/art/cursor3.png")

func _ready():
	set_cursor("point")

func set_cursor(cursor_type: String):
	match cursor_type:
		"point":
			Input.set_custom_mouse_cursor(cursor_point, Input.CURSOR_ARROW, Vector2(24, 1))
		"hit":
			Input.set_custom_mouse_cursor(cursor_hit, Input.CURSOR_ARROW, Vector2(24, 1))
		"stand":
			Input.set_custom_mouse_cursor(cursor_stand, Input.CURSOR_ARROW, Vector2(24, 1))

func on_HitButton_mouse_entered():
	set_cursor("hit")

func on_HitButton_mouse_exited():
	set_cursor("point")

func on_StayButton_mouse_entered():
	set_cursor("stand")

func on_StayButton_mouse_exited():
	set_cursor("point")
