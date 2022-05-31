extends Node2D

func _ready():
	$PlayerHealthLabel.add_font_override("font", Fonts.font_pixel_5_9)
	$OpponentHealthLabel.add_font_override("font", Fonts.font_pixel_5_9)
	$Shields/PlayerShieldLabel.add_font_override("font", Fonts.font_pixel_3_7)
	$Shields/OpponentShieldLabel.add_font_override("font", Fonts.font_pixel_3_7)
	
	$OpponentSprite.texture = load(get_parent().get_parent().opponent_sprite)
	$PlayerSprite.texture = load(get_parent().get_parent().player_sprite)

func display_shields(player_shield_value, opponent_shield_value):
	if player_shield_value > 0:
		$Shields/PlayerShieldSprite.visible = true
		$Shields/PlayerShieldLabel.text = str(player_shield_value)
	if opponent_shield_value > 0:
		$Shields/PlayerShieldSprite.visible = true
		$Shields/PlayerShieldLabel.text = str(player_shield_value)

func hide_shields():
	$Shields/PlayerShieldSprite.visible = false
	$Shields/PlayerShieldLabel.text = ""
	$Shields/OpponentShieldSprite.visible = false
	$Shields/OpponentShieldLabel.text = ""
