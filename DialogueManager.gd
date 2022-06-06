extends Node2D

#has z index of 10 set in macro controller scene to ensure it always sits in front of any gameplay elements

onready var dialogue_label = $DialogueLabel
var showing_dialogue = false
var can_clear_dialogue = false
signal dialogue_set()
signal dialogue_cleared()

func _ready():
	dialogue_label.visible = false
	$BubbleParts.visible = false
	dialogue_label.add_font_override("font", Fonts.font_pixel_5_9)

func set_dialogue_text(dialogue_string):
	dialogue_label.text = dialogue_string
	dialogue_label.visible = true
	$BubbleParts.visible = true
	showing_dialogue = true
	$StartUpDelay.start()
	emit_signal("dialogue_set")

func clear_dialogue_text():
	dialogue_label.text = ""
	dialogue_label.visible = false
	$BubbleParts.visible = false
	showing_dialogue = false
	can_clear_dialogue = false
	emit_signal("dialogue_cleared")

func _input(event):
	if event is InputEventMouseButton and showing_dialogue and can_clear_dialogue:
		if event.button_index == BUTTON_LEFT and event.pressed:
			clear_dialogue_text()

func _on_StartUpDelay_timeout():
	can_clear_dialogue = true
