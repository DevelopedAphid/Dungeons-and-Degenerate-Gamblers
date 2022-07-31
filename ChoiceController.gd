extends Node2D

var choices
var origin

export var choice_y_position = 10

onready var Card = preload("res://Card.tscn")

signal choice_made(choice_made)
signal choice_made_(origin_card, choice_array, choice_index)

signal action_choice_made(origin_card, choice_array, choice_index)

func _on_Player_card_choice_to_make(origin_card, choice_array):
	self.visible = true
	origin = origin_card
	choices = choice_array
	
	var i = 0
	for choice in choices:
		var card = Card.instance()
		card.add_to_group("choices")
#		card.position.x = i * 30 + 50
		card.position.x = 380 / choices.size() * i + 38
		card.position.y = choice_y_position
		
		if typeof(choice) == 4: #choice is a string
			card.set_card_id(choice)
		else: #choice is a card
			card.set_card_id(choice.card_id)
		
		card.set_z_index(2)
		add_child(card)
		
		#allow hovering
		card.connect("card_hover_started", get_parent().get_parent().get_node("HoverPanel"), "_on_Card_hover_started")
		card.connect("card_hover_ended", get_parent().get_parent().get_node("HoverPanel"), "_on_Card_hover_ended")
		
		card.connect("card_clicked", self, "_on_Player_card_choice_selected", [i])
		
		i += 1

func _on_Player_card_choice_selected(choice):
	emit_signal("choice_made_", origin, choices, choice) #let the deck controller know which selection was made
	emit_signal("choice_made", choice) #let the state machine know a choice has been made
	choices = null
	
	get_tree().call_group("choices", "queue_free")\
	
	self.visible = false

func _on_Player_action_choice_to_make(origin_card, choice_array):
	self.visible = true
	origin = origin_card
	choices = choice_array
	
	var i = 0
	for choice in choices:
		var card = Card.instance()
		card.add_to_group("choices")
		card.set_card_id("074") #blank card
		
		card.position.x = 380 / choices.size() * i + 38
		card.position.y = choice_y_position
		
		card.set_z_index(2)
		add_child(card)
		
		if origin.card_id == "153":
			card.set_card_name(choice)
			match choice:
				"keep":
					card.card_description = "Keep Charred Lizard in play"
				"sell":
					card.card_description = "Add Charred Lizard to your opponents draw pile and gain 25 chips"
		
		#allow hovering
		card.connect("card_hover_started", get_parent().get_parent().get_node("HoverPanel"), "_on_Card_hover_started")
		card.connect("card_hover_ended", get_parent().get_parent().get_node("HoverPanel"), "_on_Card_hover_ended")
		
		card.connect("card_clicked", self, "_on_Player_action_choice_selected", [i])
		
		i += 1

func _on_Player_action_choice_selected(choice):
	emit_signal("action_choice_made", origin, choices, choice) #let the deck controller know which selection was made
	emit_signal("choice_made", choice) #let the state machine know a choice has been made
	choices = null
	
	get_tree().call_group("choices", "queue_free")
	
	self.visible = false
