extends StaticBody2D

export var npc_type = "imp"
export var deck_list = ["006", "006", "006", "006", "006", "006"]
#export var deck_list = ["055", "055", "055", "055", "055"]
export var health_points = 100
export var flip_h: bool

var sprite_path

func _ready():
	sprite_path = "res://assets/art/characters/" + npc_type + ".png"
	$Sprite.texture = load(sprite_path)
	if flip_h:
		$Sprite.flip_h = true

func interact():
	if PlayerSettings.chosen_suit != "":
		#start game
		PlayerSettings.opponent_deck = deck_list
		PlayerSettings.opponent_sprite = sprite_path
		PlayerSettings.opponent_health_points = health_points
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://CardMat.tscn")

func _on_InteractionArea_area_entered(area):
	if area.name == "InteractionArea":
		$InteractionSprite.visible = true

func _on_InteractionArea_area_exited(area):
	if area.name == "InteractionArea":
		$InteractionSprite.visible = false
