extends StaticBody2D

func interact():
	if PlayerSettings.chosen_suit == "":
		get_parent().get_node("OverworldUI").change_choices_visibilty(true)
