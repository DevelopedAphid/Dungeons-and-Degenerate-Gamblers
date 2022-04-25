extends Node

var deck = []
var draw_pile = []
var play_pile = []
var discard_pile = []
var score = 0
var hitpoints = 100
var current_card_effect_id

var Card = preload("res://Card.tscn")

func ready():
	pass

func add_card_to_deck(card_id):
	#add a defined card to the deck
	var new_card = Card.instance()
	new_card.call_deferred("set_card_id", card_id)
	deck.append(new_card)
	
	new_card.connect("card_hover_started", get_parent().get_node("HoverZ/HoverLabel"), "_on_Card_hover_started")
	new_card.connect("card_hover_ended", get_parent().get_node("HoverZ/HoverLabel"), "_on_Card_hover_ended")

func build_draw_pile():
	#put deck list into draw pile
	for cards in deck.size():
		draw_pile.append(deck[cards])
	
	shuffle_draw_pile()
	
	update_UI()

func shuffle_draw_pile():
	#randomise draw contents
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for i in draw_pile.size():
		var random = i + rng.randi_range(0, draw_pile.size() - 1 - i)
		var temp = draw_pile[random]
		draw_pile[random] = draw_pile[i]
		draw_pile[i] = temp

func draw_top_card():
	#if not yet busted, draw the top card and enact it's effect
	
	#check draw_pile has at least 1 card first
	if draw_pile.size() == 0:
		shuffle_discard_pile_into_draw_pile()
	
	if score > 20:
		pass
	else:
		#move top draw pile card to top of play pile
		var top_card = draw_pile[0]
		
		top_card.score_before_played = score
		
		draw_pile.pop_front()
		play_pile.append(top_card)
		
		#if first time drawn then add it as a child so we can display it
		if top_card.get_parent() == null:
			add_child(top_card)
		
		update_UI()
		
		if top_card.has_special_effect():
			play_card_effect(top_card, top_card.get_card_id())
	
	update_UI()

func shuffle_discard_pile_into_draw_pile():
	#put everything in discard pile into draw pile
	for cards in discard_pile.size():
		draw_pile.append(discard_pile[cards])
	for card in discard_pile:
		card.set_card_art(card.get_card_id()) #reset card art to default
		remove_child(card)
	for cards in discard_pile.size():
		discard_pile.pop_front()
	update_UI()

func discard_played_cards():
	for cards in play_pile.size():
		discard_pile.append(play_pile[cards])
	for cards in play_pile.size():
		play_pile.pop_front()
	score = 0
	update_UI()

#func add_card_to_draw_pile(card, position):
#	#add a defined card to the draw pile at a defined position
#	pass

func update_UI():
	#todo: make this way less ugly - use signals and call from game controller instead of deck controller
	#or... make the battle sprites and health labels children of the player/opponent nodes so we can just call them as children like everything else
	if name == "Player":
		get_parent().get_node("BattleScene/PlayerHealthLabel").text = str(hitpoints)
	if name == "Opponent":
		get_parent().get_node("BattleScene/OpponentHealthLabel").text = str(hitpoints)
	
	$ScoreBar.update_score(score)
	
	$DeckDisplay.change_deck_size(draw_pile.size())
	
	var play_pile_pos = $PlayPilePosition.position
	var discard_pile_pos = $DiscardPilePosition.position
	
	var play_pile_card_spacing = 14
	var discard_pile_card_spacing = 4
	
	if name == "Opponent":
		play_pile_card_spacing = -14
		discard_pile_card_spacing = -4
	
	var play_pile_count = 0
	var discard_pile_count = 0
	for card in play_pile:
		card.position = play_pile_pos + Vector2(play_pile_card_spacing * play_pile_count, 0)
		play_pile_count += 1
	
	for card in discard_pile:
		card.position = discard_pile_pos + Vector2((discard_pile_count - 1) * discard_pile_card_spacing, 0)
		discard_pile_count += 1
	
	#todo: show that draw pile is a pile (except when only one card left)

func _on_Card_choice_to_make(choice_array, card):
	emit_signal("card_choice_to_make", choice_array, card)

func play_card_effect(card, id):
	if self.name == "Opponent": #TODO: means opponents unable to use special cards
		return
	
	current_card_effect_id = id
	
	if id == "001" || id == "014" || id == "027" || id == "040" : #aces
		var choice_array = [id, "053"]
		get_node("ChoiceController")._on_Player_card_choice_to_make(card, choice_array)
	elif id == "069": #Joker
		if discard_pile.size() > 0:
			get_node("ChoiceController")._on_Player_card_choice_to_make(card, discard_pile)
	elif id == "070": #birthday card
		card.set_card_value(card.get_card_value() + 1)
		card.set_card_name(CardList.card_dictionary["070"].name + " (" + str(card.get_card_value()) + ")")
	elif id == "071": #magic trick card
		var choice_array = ["051", "020"]
		get_node("ChoiceController")._on_Player_card_choice_to_make(card, choice_array)
	elif id == "072": #Red Joker
		if draw_pile.size() > 0:
			get_node("ChoiceController")._on_Player_card_choice_to_make(card, draw_pile)
	
	update_UI()


func _on_ChoiceController_choice_made_(origin_card, choice_array, choice_index):
	var id = current_card_effect_id
	var choice_made = choice_array[choice_index]
	
	if id == "001" || id == "014" || id == "027" || id == "040" : #aces
		origin_card.set_card_value(CardList.card_dictionary[choice_made].value)
		origin_card.set_card_art(choice_made)
		origin_card.set_card_name(CardList.card_dictionary[id].name + " (" + str(origin_card.get_card_value()) + ")")
	elif id == "069": #Joker
		origin_card.set_card_value(choice_made.get_card_value())
		origin_card.set_card_art(choice_made.get_card_id())
		origin_card.set_card_name("Joker (" + choice_made.get_card_name() + ")")
	elif id == "071": #magic trick card
		origin_card.set_card_value(CardList.card_dictionary[choice_made].value)
		origin_card.set_card_art(choice_made)
		origin_card.set_card_name(CardList.card_dictionary[id].name + " (" + CardList.card_dictionary[choice_made].name + ")")
	elif id == "072": #Red Joker
		origin_card.set_card_value(choice_made.get_card_value())
		origin_card.set_card_art(choice_made.get_card_id())
		call_deferred("play_card_effect", origin_card, choice_made.get_card_id())
	current_card_effect_id = null
	update_UI()
