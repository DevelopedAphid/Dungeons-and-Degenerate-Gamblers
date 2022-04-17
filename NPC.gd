extends StaticBody2D

func interact():
	#start game
	get_tree().change_scene("res://CardMat.tscn")

func _on_InteractionArea_area_entered(area):
	if area.name == "InteractionArea":
		$InteractionSprite.visible = true

func _on_InteractionArea_area_exited(area):
	if area.name == "InteractionArea":
		$InteractionSprite.visible = false
