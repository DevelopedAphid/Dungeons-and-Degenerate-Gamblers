extends StaticBody2D

export var deck_list = ["006", "006", "006", "006", "006", "006"]

func interact():
	if PlayerSettings.chosen_suit != "":
		#start game
		PlayerSettings.opponent_deck = deck_list
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://CardMat.tscn")

func _on_InteractionArea_area_entered(area):
	if area.name == "InteractionArea":
		$InteractionSprite.visible = true

func _on_InteractionArea_area_exited(area):
	if area.name == "InteractionArea":
		$InteractionSprite.visible = false
