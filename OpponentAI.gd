extends Node2D

func _ready():
	pass # Replace with function body.

func will_hit() -> bool:
	if get_parent().score < 17:
		return true
	else:
		return false


func _on_Opponent_card_choice_to_make(choice_array):
	pass #later code goes here to tell opponent AI to make a card choice
