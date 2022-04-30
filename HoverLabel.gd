extends Label

var hovered_cards = []
var hover_position = Vector2(62, 5)

onready var font = Fonts.font_pixel_5_9

onready var bg_panel = get_parent().get_node("BackgroundPanel")

func _ready():
	add_font_override("font", font)
	get_parent().set_z_index(3)

func find_and_focus_top_card():
	var top_card
	var top_index = 0
	
	for current_card in hovered_cards:
		current_card.set_z_index(0)
		current_card.highlight_card(false)
		current_card.get_parent().get_node("ScoreBar").remove_highlights()
		var index = current_card.get_index()
		if index > top_index:
			top_card = current_card
			top_index = index
	
	top_card.set_z_index(1)
	top_card.highlight_card(true)
	
	text = top_card.card_name
	rect_size = font.get_string_size(top_card.card_name)
	rect_position.x = top_card.position.x + hover_position.x
	rect_position.y = top_card.position.y + hover_position.y
	visible = true
	bg_panel.rect_size = rect_size
	bg_panel.rect_position = rect_position
	
	#check if it fits on the screen and re-position if it doesn't
	if bg_panel.rect_position.x + bg_panel.rect_size.x > get_viewport_rect().size.x - 10:
		bg_panel.rect_position.x = get_viewport_rect().size.x - bg_panel.rect_size.x - 10
		rect_position.x = bg_panel.rect_position.x
	if bg_panel.rect_position.y + bg_panel.rect_size.y > get_viewport_rect().size.y - 10:
		bg_panel.rect_position.y = get_viewport_rect().size.y - bg_panel.rect_size.y - 10
		rect_position.y = bg_panel.rect_position.y
	
	bg_panel.visible = true
	
	top_card.get_parent().get_node("ScoreBar").highlight_scores(top_card.score_before_played + 1, top_card.score_before_played + top_card.get_card_value())

func _on_Card_hover_started(card):
	hovered_cards.append(card)
	
	find_and_focus_top_card()

func _on_Card_hover_ended(card):
	hovered_cards.erase(card)
	card.set_z_index(0)
	card.highlight_card(false)
	card.get_parent().get_node("ScoreBar").remove_highlights()
	
	if hovered_cards.size() == 0:
		visible = false
		bg_panel.visible = false
	else:
		find_and_focus_top_card()
