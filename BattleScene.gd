extends Node2D

func _ready():
	$PlayerHealthLabel.add_font_override("font", Fonts.font_pixel_5_9)
	$OpponentHealthLabel.add_font_override("font", Fonts.font_pixel_5_9)
