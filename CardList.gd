extends Node

var card_dictionary = {
	"001": {
		"name": "Ace of Spades",
		"suit": "spades",
		"value": 1
	},
	"002": {
		"name": "Two of Spades",
		"suit": "spades",
		"value": 2
	},
	"003": {
		"name": "Three of Spades",
		"suit": "spades",
		"value": 3
	},
	"004": {
		"name": "Four of Spades",
		"suit": "spades",
		"value": 4
	},
	"005": {
		"name": "Five of Spades",
		"suit": "spades",
		"value": 5
	},
	"006": {
		"name": "Six of Spades",
		"suit": "spades",
		"value": 6
	},
	"007": {
		"name": "Seven of Spades",
		"suit": "spades",
		"value": 7
	},
	"008": {
		"name": "Eight of Spades",
		"suit": "spades",
		"value": 8
	},
	"009": {
		"name": "Nine of Spades",
		"suit": "spades",
		"value": 9
	},
	"010": {
		"name": "Ten of Spades",
		"suit": "spades",
		"value": 10
	},
	"011": {
		"name": "Jack of Spades",
		"suit": "spades",
		"value": "J"
	},
	"012": {
		"name": "Queen of Spades",
		"suit": "spades",
		"value": "Q"
	},
	"013": {
		"name": "King of Spades",
		"suit": "spades",
		"value": "K"
	},
	"014": {
		"name": "Ace of Clubs",
		"suit": "clubs",
		"value": 1
	},
	"015": {
		"name": "Two of Clubs",
		"suit": "clubs",
		"value": 2
	},
	"016": {
		"name": "Three of Clubs",
		"suit": "clubs",
		"value": 3
	},
	"017": {
		"name": "Four of Clubs",
		"suit": "clubs",
		"value": 4
	},
	"018": {
		"name": "Five of Clubs",
		"suit": "clubs",
		"value": 5
	},
	"019": {
		"name": "Six of Clubs",
		"suit": "clubs",
		"value": 6
	},
	"020": {
		"name": "Seven of Clubs",
		"suit": "clubs",
		"value": 7
	},
	"021": {
		"name": "Eight of Clubs",
		"suit": "clubs",
		"value": 8
	},
	"022": {
		"name": "Nine of Clubs",
		"suit": "clubs",
		"value": 9
	},
	"023": {
		"name": "Ten of Clubs",
		"suit": "clubs",
		"value": 10
	},
	"024": {
		"name": "Jack of Clubs",
		"suit": "clubs",
		"value": "J"
	},
	"025": {
		"name": "Queen of Clubs",
		"suit": "clubs",
		"value": "Q"
	},
	"026": {
		"name": "King of Clubs",
		"suit": "clubs",
		"value": "K"
	},
	"027": {
		"name": "Ace of Diamonds",
		"suit": "diamonds",
		"value": 1
	},
	"028": {
		"name": "Two of Diamonds",
		"suit": "diamonds",
		"value": 2
	},
	"029": {
		"name": "Three of Diamonds",
		"suit": "diamonds",
		"value": 3
	},
	"030": {
		"name": "Four of Diamonds",
		"suit": "diamonds",
		"value": 4
	},
	"031": {
		"name": "Five of Diamonds",
		"suit": "diamonds",
		"value": 5
	},
	"032": {
		"name": "Six of Diamonds",
		"suit": "diamonds",
		"value": 6
	},
	"033": {
		"name": "Seven of Diamonds",
		"suit": "diamonds",
		"value": 7
	},
	"034": {
		"name": "Eight of Diamonds",
		"suit": "diamonds",
		"value": 8
	},
	"035": {
		"name": "Nine of Diamonds",
		"suit": "diamonds",
		"value": 9
	},
	"036": {
		"name": "Ten of Diamonds",
		"suit": "diamonds",
		"value": 10
	},
	"037": {
		"name": "Jack of Diamonds",
		"suit": "diamonds",
		"value": "J"
	},
	"038": {
		"name": "Queen of Diamonds",
		"suit": "diamonds",
		"value": "Q"
	},
	"039": {
		"name": "King of Diamonds",
		"suit": "diamonds",
		"value": "K"
	},
	"040": {
		"name": "Ace of Hearts",
		"suit": "hearts",
		"value": 1
	},
	"041": {
		"name": "Two of Hearts",
		"suit": "hearts",
		"value": 2
	},
	"042": {
		"name": "Three of Hearts",
		"suit": "hearts",
		"value": 3
	},
	"043": {
		"name": "Four of Hearts",
		"suit": "hearts",
		"value": 4
	},
	"044": {
		"name": "Five of Hearts",
		"suit": "hearts",
		"value": 5
	},
	"045": {
		"name": "Six of Hearts",
		"suit": "hearts",
		"value": 6
	},
	"046": {
		"name": "Seven of Hearts",
		"suit": "hearts",
		"value": 7
	},
	"047": {
		"name": "Eight of Hearts",
		"suit": "hearts",
		"value": 8
	},
	"048": {
		"name": "Nine of Hearts",
		"suit": "hearts",
		"value": 9
	},
	"049": {
		"name": "Ten of Hearts",
		"suit": "hearts",
		"value": 10
	},
	"050": {
		"name": "Jack of Hearts",
		"suit": "hearts",
		"value": "J"
	},
	"051": {
		"name": "Queen of Hearts",
		"suit": "hearts",
		"value": "Q"
	},
	"052": {
		"name": "King of Hearts",
		"suit": "hearts",
		"value": "K"
	},
	"053": {
		"name": "Eleven of Spades",
		"suit": "spades",
		"value": 11
	},
	"054": {
		"name": "Twelve of Spades",
		"suit": "spades",
		"value": 12
	},
	"055": {
		"name": "Thirteen of Spades",
		"suit": "spades",
		"value": 13
	},
	"056": {
		"name": "Eleven of Clubs",
		"suit": "clubs",
		"value": 11
	},
	"057": {
		"name": "Twelve of Clubs",
		"suit": "clubs",
		"value": 12
	},
	"058": {
		"name": "Thirteen of Clubs",
		"suit": "clubs",
		"value": 13
	},
	"059": {
		"name": "Eleven of Diamonds",
		"suit": "diamonds",
		"value": 11
	},
	"060": {
		"name": "Twelve of Diamonds",
		"suit": "diamonds",
		"value": 12
	},
	"061": {
		"name": "Thirteen of Diamonds",
		"suit": "diamonds",
		"value": 13
	},
	"062": {
		"name": "Eleven of Hearts",
		"suit": "hearts",
		"value": 11
	},
	"063": {
		"name": "Twelve of Hearts",
		"suit": "hearts",
		"value": 12
	},
	"064": {
		"name": "Thirteen of Hearts",
		"suit": "hearts",
		"value": 13
	},
	"065": {
		"name": "Twenty One of Spades",
		"suit": "spades",
		"value": 21
	},
	"066": {
		"name": "Twenty One of Clubs",
		"suit": "clubs",
		"value": 21
	},
	"067": {
		"name": "Twenty One of Diamonds",
		"suit": "diamonds",
		"value": 21
	},
	"068": {
		"name": "Twenty One of Hearts",
		"suit": "hearts",
		"value": 21
	},
	"069": {
		"name": "Joker",
		"suit": "special",
		"value": "Joker"
	},
	"070": {
		"name": "Birthday Card",
		"suit": "special",
		"value": 0
	}
}
