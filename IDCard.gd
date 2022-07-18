extends Node2D

onready var font_5_9 = Fonts.font_pixel_5_9
onready var font_3_7 = Fonts.font_pixel_3_7

var current_hitpoints: int
var max_hitpoints: int
var current_shieldpoints: int

onready var hp_change_label_pos = $HPChangeLabel.rect_position

func _ready():
	$NameLabel.add_font_override("font", font_5_9)
	$HPLabel.add_font_override("font", font_5_9)
	$HPChangeLabel.add_font_override("font", font_3_7)
	$ShieldLabel.add_font_override("font", font_5_9)

func initialise_id_card(name: String, portrait_path: String, 
chips: int, starting_health: int, max_health: int):
	set_name(name)
	$PortraitSprite.texture = load(portrait_path)
	change_chips(chips)
	max_hitpoints = max_health
	change_hitpoints(starting_health)

func set_name(name: String):
	$NameLabel.text = name

func change_chips(chips):
	$ChipCounter.change_chip_number(chips)

func change_hitpoints(new_health):
	var health_difference = new_health - current_hitpoints
	current_hitpoints = new_health
	$HPLabel.text = str(current_hitpoints) + "/" + str(max_hitpoints)
	
	if abs(health_difference) > 0:
		$HPChangeLabel.text = str(health_difference)
		#fade text
		var text_tween = Tween.new()
		add_child(text_tween)
		text_tween.interpolate_property($HPChangeLabel, "modulate:a", 1.0, 0.0, 0.5)
		text_tween.start()
		#move text upward slightly
		var pos_tween = Tween.new()
		add_child(pos_tween)
		pos_tween.interpolate_property($HPChangeLabel, "rect_position", hp_change_label_pos, hp_change_label_pos + Vector2(0, -5), 0.5)
		pos_tween.start()

func change_shieldpoints(new_shield):
	$ShieldCounter.visible = false
	current_shieldpoints = new_shield
	
	if current_shieldpoints > 0:
		$ShieldLabel.text = str(current_shieldpoints)
		$ShieldCounter.visible = true
