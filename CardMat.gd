extends Node2D

var player_deck = []
var player_cards_in_play = []
var player_cards_discarded = []
var opponent_deck = []
var opponent_cards_in_play = []
var opponent_cards_discarded = []
var player_score = 0
var opponent_score = 0
var rng
var starting_suit

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
	reset_game()

func reset_game():
	starting_suit = PlayerSettings.chosen_suit
	
	player_deck = []
	player_cards_in_play = []
	player_cards_discarded = []
	player_score = 0
	
	opponent_deck = []
	opponent_cards_in_play = []
	opponent_cards_discarded = []
	opponent_score = 0
	
	get_node("PlayerDeckLabel").text = ""
	get_node("PlayerInPlayLabel").text = ""
	get_node("PlayerDiscardLabel").text = ""
	get_node("HitButton").text = "0"
	
	get_node("OpponentDeckLabel").text = ""
	
	var first_card_index
	if starting_suit == "spades":
		first_card_index = 1
	elif starting_suit == "clubs":
		first_card_index = 14
	elif starting_suit == "diamonds":
		first_card_index = 27
	elif starting_suit == "hearts":
		first_card_index = 40
	
	for n in 13: #all cards of one suit
		player_deck.append(n + first_card_index)
		opponent_deck.append(n + 1)

func _on_ShuffleButton_pressed():
	reset_game()
	shuffle_deck(player_deck)
	shuffle_deck(opponent_deck)

func shuffle_deck(deck_to_shuffle):
	#shuffle the deck
	for i in deck_to_shuffle.size():
		var random = i + rng.randi_range(0, deck_to_shuffle.size() - 1 - i)
		var temp = deck_to_shuffle[random]
		deck_to_shuffle[random] = deck_to_shuffle[i]
		deck_to_shuffle[i] = temp
	
	update_deck_contents_list()

func _on_HitButton_pressed():
	#if no cards remaining
	if player_deck.size() == 0: 
		shuffle_discard_into_deck(player_cards_discarded, player_deck)
	
	#move top card from deck to be bottom of in play list
	var top_card = player_deck[0]
	player_cards_in_play.append(top_card)
	player_deck.pop_front()
	
	player_score = player_score + get_card_value(top_card)
	
	var hit_button = get_node("HitButton")
	hit_button.text = str(player_score)
	
	if player_score > 20:
		if player_score > 21:
			hit_button.text = "BUST"
		
		for cards in player_cards_in_play.size():
			player_cards_discarded.append(player_cards_in_play[cards])
		for cards in player_cards_in_play.size():
			player_cards_in_play.pop_front()
		player_score = 0
		
		for cards in opponent_cards_in_play.size():
			opponent_cards_discarded.append(opponent_cards_in_play[cards])
		for cards in opponent_cards_in_play.size():
			opponent_cards_in_play.pop_front()
		opponent_score = 0
	
	else:
		#opponent turn
		#if no cards remaining
		if opponent_deck.size() == 0:
			shuffle_discard_into_deck(opponent_cards_discarded, opponent_deck)
		
		#dealer stays at 17 or more
		if opponent_score < 17:
			#move top card from deck to be bottom of in play list
			var opponent_top_card = opponent_deck[0]
			opponent_cards_in_play.append(opponent_top_card)
			opponent_deck.pop_front()
		
			opponent_score = opponent_score + get_card_value(opponent_top_card)
		
		var opponent_score_label = get_node("OpponentScoreLabel")
		opponent_score_label.text = str(opponent_score)
		
		if opponent_score > 20:
			if opponent_score > 21:
				opponent_score_label.text = "BUST"
		
			for cards in opponent_cards_in_play.size():
				opponent_cards_discarded.append(opponent_cards_in_play[cards])
			for cards in opponent_cards_in_play.size():
				opponent_cards_in_play.pop_front()
			opponent_score = 0
	
	update_deck_contents_list()
	update_cards_in_play_list()
	update_cards_discarded_list()

func update_label_from_array(label, array):
	label.text = ""
	for items in array:
		if items < 10:
			label.text = label.text + "\n" + CardList.card_dictionary.get("00" + str(items)).name
		else:
			label.text = label.text + "\n" + CardList.card_dictionary.get("0" + str(items)).name

func update_deck_contents_list():
	var deck_label = get_node("PlayerDeckLabel")
	update_label_from_array(deck_label, player_deck)
	
	var opponent_deck_label = get_node("OpponentDeckLabel")
	update_label_from_array(opponent_deck_label, opponent_deck)

func update_cards_in_play_list():
	var in_play_label = get_node("PlayerInPlayLabel")
	update_label_from_array(in_play_label, player_cards_in_play)
	
	var opponent_in_play_label = get_node("OpponentInPlayLabel")
	update_label_from_array(opponent_in_play_label, opponent_cards_in_play)

func update_cards_discarded_list():
	var discard_label = get_node("PlayerDiscardLabel")
	update_label_from_array(discard_label, player_cards_discarded)
	
	var opponent_discard_label = get_node("OpponentDiscardLabel")
	update_label_from_array(opponent_discard_label, opponent_cards_discarded)

func get_card_value(card) -> int:
	var card_value
	if card < 10:
		card_value = CardList.card_dictionary.get("00" + str(card)).value
	else:
		card_value = CardList.card_dictionary.get("0" + str(card)).value
	if typeof(card_value) == 4: #if value is a string
		if card_value == "J" || card_value == "Q" || card_value == "K":
			card_value = 10
	return card_value

func shuffle_discard_into_deck(cards_discarded, deck_to_shuffle_into):
	for cards in cards_discarded.size():
		deck_to_shuffle_into.append(cards_discarded[cards])
	for cards in cards_discarded.size():
		cards_discarded.pop_front()
	
	shuffle_deck(deck_to_shuffle_into)
