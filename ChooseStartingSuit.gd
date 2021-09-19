extends Control

func update_chosen_suit(suit):
	PlayerSettings.chosen_suit = suit

func _on_SpadesButton_pressed():
	update_chosen_suit("spades")
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://CardMat.tscn")

func _on_DiamondsButton_pressed():
	update_chosen_suit("diamonds")
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://CardMat.tscn")

func _on_ClubsButton_pressed():
	update_chosen_suit("clubs")
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://CardMat.tscn")

func _on_HeartsButton_pressed():
	update_chosen_suit("hearts")
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://CardMat.tscn")
