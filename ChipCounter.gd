extends Node2D

var last_chip_count

func _ready():
	$Label.add_font_override("font", Fonts.font_pixel_5_9)

func change_chip_number(chip_count: int):
	if chip_count != last_chip_count:
		$Label.text = str(chip_count)
		$AnimatedSprite.play("spin_chip")
		last_chip_count = chip_count

func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.stop()
