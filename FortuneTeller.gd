extends Node2D

signal tarot_card_chosen

onready var font = Fonts.font_pixel_5_9

onready var macro_controller = get_parent()
var card1_flipped = false
var card2_flipped = false
var card3_flipped = false

func _ready():
	connect_to_card_backs()
	$CardLabel.add_font_override("font", font)

func connect_to_card_backs():
	for card in $Cards.get_children():
		card.set_card_id(card.card_id)
		card.connect("card_hover_started", get_node("HoverPanel"), "_on_Card_hover_started")
		card.connect("card_hover_ended", get_node("HoverPanel"), "_on_Card_hover_ended")
		card.connect("card_clicked", self, "_on_CardBack_clicked", [card])

func _on_CardBack_clicked(card):
	if card1_flipped && card2_flipped && card3_flipped: #if all flipped then add card to deck and move on
		macro_controller.player_deck.append(card.card_id)
		emit_signal("tarot_card_chosen")
		print("all flipped")
	
	var index = card.get_index()
	match index: #check if card already flipped and skip if it is, otherwise mark it as flipped
		0:
			if card1_flipped:
				return
			else: 
				card1_flipped = true
		1:
			if card2_flipped:
				return
			else:
				card2_flipped = true
		2:
			if card3_flipped:
				return
			else:
				card3_flipped = true
	
	var tarot_id = CardList.get_random_tarot_card_id()
	card.set_card_id(tarot_id)
	$CardLabel.modulate.a = 1.0 #set to be fully opaque again
	$CardLabel.text = get_tarot_message(tarot_id)
	$CardLabel/CardLabelTimer.start()

func get_tarot_message(card_id) -> String:
	match card_id:
		"123":
			return "As above, so below"
		"124":
			return "Secrets, mystery, the future yet unrevealed"
		"125":
			return "Mother, creator, nurturing"
		"126":
			return "Stability, power, protection"
		"127":
			return "Mercy, goodness, alliance"
		"128":
			return "Attraction, a choice or a sacrifice, love "
		"129":
			return "Triumph, vengeance, war"
		"130":
			return "Balance and equity"
		"131":
			return "Advice, introspection, recovery"
		"132":
			return "Luck, success, destiny"
		"133":
			return "Courage, action, power"
		"134":
			return "Trials and sacrifice resulting in enlightenment, wisdom"
		"135":
			return "Corruption, destruction, the end"
		"136":
			return "Moderation, frugality, patience, attainment of a goal"
		"137":
			return "Violence, extraordinary efforts, predestined fate"
		"138":
			return "Misery brought on by sudden, destructive change"
		"139":
			return "Inspiration, hope, the end of troubled times"
		"140":
			return "Danger, enemies unknown, deception"
		"141":
			return "Happiness, contentment, success, self-confidence"
		"142":
			return "Absolution, resurrection, a second chance"
		"143":
			return "A journey, completeness, the end of a cycle"
		"144":
			return "Folly, mania, frenzy"
	
	return "" #something went wrong, return empty string

func _on_CardLabelTimer_timeout():
	var visiblity_tween = Tween.new()
	add_child(visiblity_tween)
	visiblity_tween.interpolate_property($CardLabel, "modulate:a", 1.0, 0.0, 0.5)
	visiblity_tween.start()
