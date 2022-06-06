extends Node2D

var player_sprite_orig_pos
var opponent_sprite_orig_pos
var attack_anim_pixels = Vector2(5, 0)
var attack_anim_duration = 0.1
var player_damage_label_orig_pos
var opponent_damage_label_orig_pos

onready var player = get_parent().get_node("Player")
onready var opponent = get_parent().get_node("Opponent")

func _ready():
	$PlayerHealthLabel.add_font_override("font", Fonts.font_pixel_5_9)
	$PlayerDamageLabel.add_font_override("font", Fonts.font_pixel_3_7)
	$OpponentHealthLabel.add_font_override("font", Fonts.font_pixel_5_9)
	$OpponentDamageLabel.add_font_override("font", Fonts.font_pixel_3_7)
	$Shields/PlayerShieldLabel.add_font_override("font", Fonts.font_pixel_3_7)
	$Shields/OpponentShieldLabel.add_font_override("font", Fonts.font_pixel_3_7)
	
	$OpponentSprite.texture = load(get_parent().get_parent().opponent_sprite)
	$PlayerSprite.texture = load(get_parent().get_parent().player_sprite)
	
	player_sprite_orig_pos = $PlayerSprite.position
	opponent_sprite_orig_pos = $OpponentSprite.position
	player_damage_label_orig_pos = $PlayerDamageLabel.rect_position
	opponent_damage_label_orig_pos = $OpponentDamageLabel.rect_position

func update_health_points():
	$PlayerHealthLabel.text = str(player.hitpoints) + "/" + str(player.max_hitpoints)
	$OpponentHealthLabel.text = str(opponent.hitpoints) + "/" + str(opponent.max_hitpoints)

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

func play_attack_animation(player_should_attack: bool, opponent_should_attack: bool):
	var player_tween = Tween.new()
	add_child(player_tween)
	player_tween.interpolate_property($PlayerSprite, "position", $PlayerSprite.position, $PlayerSprite.position + attack_anim_pixels * int(player_should_attack), attack_anim_duration)
	player_tween.start()
	var opponent_tween = Tween.new()
	add_child(opponent_tween)
	opponent_tween.interpolate_property($OpponentSprite, "position", $OpponentSprite.position, $OpponentSprite.position - attack_anim_pixels * int(opponent_should_attack), attack_anim_duration)
	opponent_tween.start()
	yield(opponent_tween, "tween_all_completed")
	player_tween.interpolate_property($PlayerSprite, "position", $PlayerSprite.position, player_sprite_orig_pos, attack_anim_duration)
	player_tween.start()
	opponent_tween.interpolate_property($OpponentSprite, "position", $OpponentSprite.position, opponent_sprite_orig_pos, attack_anim_duration)
	opponent_tween.start()

func play_damage_animation(target, damage_amount: int):
	if target.name == "Player":
		#show damage in text
		$PlayerDamageLabel.text = "-" + str(damage_amount)
		#fade text
		var text_tween = Tween.new()
		add_child(text_tween)
		text_tween.interpolate_property($PlayerDamageLabel, "modulate:a", 1.0, 0.0, 0.5)
		text_tween.start()
		#move text upward slightly
		var pos_tween = Tween.new()
		add_child(pos_tween)
		pos_tween.interpolate_property($PlayerDamageLabel, "rect_position", player_damage_label_orig_pos, player_damage_label_orig_pos + Vector2(0, -5), 0.5)
		pos_tween.start()
	elif target.name == "Opponent":
		#show damage in text
		$OpponentDamageLabel.text = "-" + str(damage_amount)
		var text_tween = Tween.new()
		add_child(text_tween)
		text_tween.interpolate_property($OpponentDamageLabel, "modulate:a", 1.0, 0.0, 0.5)
		text_tween.start()
		var pos_tween = Tween.new()
		add_child(pos_tween)
		pos_tween.interpolate_property($OpponentDamageLabel, "rect_position", opponent_damage_label_orig_pos, opponent_damage_label_orig_pos + Vector2(0, -5), 0.5)
		pos_tween.start()

func set_turn_indicator(is_player_turn: bool):
	if is_player_turn:
		$TurnIndicator.position = Vector2(-5, 30)
		$TurnIndicator.flip_h = true
	else:
		$TurnIndicator.position = Vector2(266, 30)
		$TurnIndicator.flip_h = false
