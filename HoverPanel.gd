extends Node2D

var hovered_cards = []
var hover_position = Vector2(52, 9)
var badge_position_offset = Vector2(49, -5)

onready var font = Fonts.font_pixel_5_9
onready var description_font = Fonts.font_pixel_3_7

onready var hover_label = get_node("HoverLabel")
onready var description_label = get_node("DescriptionLabel")
onready var score_badge = get_node("BadgeSprite")
onready var score_label = get_node("BadgeLabel")

func _ready():
	hover_label.add_font_override("font", font)
	description_label.add_font_override("font", description_font)
	score_label.add_font_override("font", description_font)
	set_z_index(3)
 
func find_and_focus_top_card():
	var top_card
	var top_index = 0
	
	if hovered_cards.size() > 1:
		for current_card in hovered_cards:
			current_card.highlight_card(false)
			if current_card.is_in_group("choices"):
				current_card.set_z_index(2)
			else: #choices don't have a score contribution to highlight
				current_card.get_parent().get_node("ScoreBar").remove_highlights()
				current_card.set_z_index(0)
			var index = current_card.get_index()
			if index > top_index:
				top_card = current_card
				top_index = index
	else:
		top_card = hovered_cards[0]
	
	if top_card.is_in_group("choices"):
		top_card.set_z_index(3)
	else:
		top_card.set_z_index(1)
	top_card.highlight_card(true)
	
	var card_name
	if top_card.card_shrouded == true:
		card_name = "???"
	else:
		card_name = top_card.card_name
	hover_label.text = card_name
	hover_label.rect_size = font.get_string_size(card_name)
	hover_label.rect_position = top_card.position + hover_position
	
	#check if it fits on the screen and re-position if it doesn't
	if hover_label.rect_position.x + hover_label.rect_size.x > get_viewport_rect().size.x - 10:
		hover_label.rect_position.x = get_viewport_rect().size.x - hover_label.rect_size.x - 10
	if hover_label.rect_position.y + hover_label.rect_size.y > get_viewport_rect().size.y - 10:
		hover_label.rect_position.y = get_viewport_rect().size.y - hover_label.rect_size.y - 10
	
	var card_desc
	if top_card.card_shrouded == true:
		card_desc = "???"
	else:
		card_desc = top_card.card_description
	description_label.text = card_desc
	description_label.rect_size = description_font.get_string_size(card_desc)
	description_label.rect_position = hover_label.rect_position + Vector2(0, 11)
	
	#check if it fits on the screen and re-position if it doesn't
	if description_label.rect_position.x + description_label.rect_size.x > get_viewport_rect().size.x - 10:
		description_label.rect_position.x = get_viewport_rect().size.x - description_label.rect_size.x - 10
		hover_label.rect_position.x = description_label.rect_position.x
	if description_label.rect_position.y + description_label.rect_size.y > get_viewport_rect().size.y - 10:
		description_label.rect_position.y = get_viewport_rect().size.y - description_label.rect_size.y - 10
		hover_label.rect_position.y = description_label.rect_position.y - 11
	
	#position all the bubble sprites
	var tile_size = 5
	var hover_size = Vector2(0, 0)
	var padding = 3
	hover_size.x = max(hover_label.rect_size.x, description_label.rect_size.x) + padding
	hover_size.y = hover_label.rect_size.y + description_label.rect_size.y + padding
	$BubbleParts/TopLeftBubble.position = hover_label.rect_position + Vector2(-padding, -padding)
	$BubbleParts/TopMiddleBubble.position = hover_label.rect_position + Vector2(tile_size, 0) + Vector2(-padding, -padding)
	$BubbleParts/TopMiddleBubble.scale.x = (hover_size.x - tile_size*2 + 2*padding) / tile_size
	$BubbleParts/TopRightBubble.position = hover_label.rect_position + Vector2(hover_size.x - tile_size, 0) + Vector2(padding, -padding)
	$BubbleParts/MiddleLeftBubble.position = hover_label.rect_position + Vector2(0, tile_size) + Vector2(-padding, -padding)
	$BubbleParts/MiddleLeftBubble.scale.y = (hover_size.y - tile_size*2 + 2*padding) / tile_size
	$BubbleParts/MiddleRightBubble.position = hover_label.rect_position + Vector2(hover_size.x - tile_size, tile_size) + Vector2(padding, -padding)
	$BubbleParts/MiddleRightBubble.scale.y = (hover_size.y - tile_size*2 + 2*padding) / tile_size
	$BubbleParts/BottomLeftBubble.position = hover_label.rect_position + Vector2(0, hover_size.y - tile_size) + Vector2(-padding, padding)
	$BubbleParts/BottomMiddleBubble.position = hover_label.rect_position + Vector2(5, hover_size.y - tile_size) + Vector2(-padding, padding)
	$BubbleParts/BottomMiddleBubble.scale.x = (hover_size.x - tile_size*2 + 2*padding) / tile_size
	$BubbleParts/BottomRightBubble.position = hover_label.rect_position + Vector2(hover_size.x - tile_size, hover_size.y -  tile_size) + Vector2(padding, padding)
	$BubbleParts/MiddleMiddleBubble.position = hover_label.rect_position + Vector2(tile_size, tile_size) + Vector2(-padding, -padding)
	$BubbleParts/MiddleMiddleBubble.scale.x = (hover_size.x - tile_size*2 + 2*padding) / tile_size
	$BubbleParts/MiddleMiddleBubble.scale.y = (hover_size.y - tile_size*2 + 2*padding) / tile_size
	
	description_label.visible = true
	hover_label.visible = true
	$BubbleParts.visible = true
	
	score_badge.position = top_card.position + badge_position_offset
	score_label.text = str(top_card.card_value)
	var label_position_offset
	if top_card.card_value < 10:
		label_position_offset = Vector2(3, 2)
	else:
		label_position_offset = Vector2(1, 2)
	score_label.rect_position = score_badge.position + label_position_offset
	score_badge.visible = true
	score_label.visible = true
	
	if not top_card.is_in_group("choices"): #choices and sleeve cards don't have a score contribution to highlight
		if not top_card.is_in_group("sleeve_cards"):
			if not top_card.card_shrouded:
				top_card.get_parent().get_node("ScoreBar").highlight_scores(top_card.score_before_played + 1, top_card.score_before_played + top_card.get_card_value())

func _on_Card_hover_started(card):
	hovered_cards.append(card)
	find_and_focus_top_card()

func _on_Card_hover_ended(card):
	hovered_cards.erase(card)
	if card.is_in_group("choices"):
		card.set_z_index(2)
	else:
		card.set_z_index(0)
	card.highlight_card(false)
	if not card.is_in_group("choices"): #choices don't have a score contribution to highlight
		card.get_parent().get_node("ScoreBar").remove_highlights()
	
	if hovered_cards.size() == 0:
		hover_label.visible = false
		description_label.visible = false
		$BubbleParts.visible = false
		score_badge.visible = false
		score_label.visible = false
	else:
		find_and_focus_top_card()
