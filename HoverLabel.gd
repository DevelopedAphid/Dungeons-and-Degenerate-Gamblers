extends Label

var hovered_cards = []
var hover_position = Vector2(62, 5)

func _ready():
	add_font_override("font", Fonts.font_pixel_5_9)
	get_parent().set_z_index(3)

func find_and_focus_top_card():
	var top_card
	var top_index = 0
	
	for current_card in hovered_cards:
		current_card.set_z_index(0)
		current_card.highlight_card(false)
		var index = current_card.get_index()
		if index > top_index:
			top_card = current_card
			top_index = index
	
	top_card.set_z_index(1)
	top_card.highlight_card(true)
	
	text = top_card.card_name
	rect_position.x = top_card.position.x + hover_position.x
	rect_position.y = top_card.position.y + hover_position.y
	visible = true

func _on_Card_hover_started(card):
	hovered_cards.append(card)
	
	find_and_focus_top_card()

func _on_Card_hover_ended(card):
	hovered_cards.erase(card)
	card.set_z_index(0)
	card.highlight_card(false)
	
	if hovered_cards.size() == 0:
		visible = false
	else:
		find_and_focus_top_card()
