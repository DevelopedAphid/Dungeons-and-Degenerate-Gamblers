extends Node

var font_pixel_5_9
var font_pixel_5_9_texture = preload("res://assets/fonts/font_sheet.png")

func _ready():
	font_pixel_5_9 = BitmapFont.new()
	font_pixel_5_9.add_texture(font_pixel_5_9_texture)
	font_pixel_5_9.set_height(9)
	var chars = "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ.,() "
	
	for i in range (0, chars.length()):
		if chars[i] == "." or chars[i] == "," or chars[i] == " ": #skinny characters
			font_pixel_5_9.add_char(chars.ord_at(i), 0, Rect2(6 * i, 0, 4, 9))
		else:
			font_pixel_5_9.add_char(chars.ord_at(i), 0, Rect2(6 * i, 0, 6, 9))
	
