extends Node

var card_dictionary = {
	"001": {
		"name": "Ace of Spades",
		"suit": "spades",
		"value": 1,
		"effect": true
	},
	"002": {
		"name": "Two of Spades",
		"suit": "spades",
		"value": 2,
		"effect": false
	},
	"003": {
		"name": "Three of Spades",
		"suit": "spades",
		"value": 3,
		"effect": false
	},
	"004": {
		"name": "Four of Spades",
		"suit": "spades",
		"value": 4,
		"effect": false
	},
	"005": {
		"name": "Five of Spades",
		"suit": "spades",
		"value": 5,
		"effect": false
	},
	"006": {
		"name": "Six of Spades",
		"suit": "spades",
		"value": 6,
		"effect": false
	},
	"007": {
		"name": "Seven of Spades",
		"suit": "spades",
		"value": 7,
		"effect": false
	},
	"008": {
		"name": "Eight of Spades",
		"suit": "spades",
		"value": 8,
		"effect": false
	},
	"009": {
		"name": "Nine of Spades",
		"suit": "spades",
		"value": 9,
		"effect": false
	},
	"010": {
		"name": "Ten of Spades",
		"suit": "spades",
		"value": 10,
		"effect": false
	},
	"011": {
		"name": "Jack of Spades",
		"suit": "spades",
		"value": "J",
		"effect": false
	},
	"012": {
		"name": "Queen of Spades",
		"suit": "spades",
		"value": "Q",
		"effect": false
	},
	"013": {
		"name": "King of Spades",
		"suit": "spades",
		"value": "K",
		"effect": false
	},
	"014": {
		"name": "Ace of Clubs",
		"suit": "clubs",
		"value": 1,
		"effect": true
	},
	"015": {
		"name": "Two of Clubs",
		"suit": "clubs",
		"value": 2,
		"effect": false
	},
	"016": {
		"name": "Three of Clubs",
		"suit": "clubs",
		"value": 3,
		"effect": false
	},
	"017": {
		"name": "Four of Clubs",
		"suit": "clubs",
		"value": 4,
		"effect": false
	},
	"018": {
		"name": "Five of Clubs",
		"suit": "clubs",
		"value": 5,
		"effect": false
	},
	"019": {
		"name": "Six of Clubs",
		"suit": "clubs",
		"value": 6,
		"effect": false
	},
	"020": {
		"name": "Seven of Clubs",
		"suit": "clubs",
		"value": 7,
		"effect": false
	},
	"021": {
		"name": "Eight of Clubs",
		"suit": "clubs",
		"value": 8,
		"effect": false
	},
	"022": {
		"name": "Nine of Clubs",
		"suit": "clubs",
		"value": 9,
		"effect": false
	},
	"023": {
		"name": "Ten of Clubs",
		"suit": "clubs",
		"value": 10,
		"effect": false
	},
	"024": {
		"name": "Jack of Clubs",
		"suit": "clubs",
		"value": "J",
		"effect": false
	},
	"025": {
		"name": "Queen of Clubs",
		"suit": "clubs",
		"value": "Q",
		"effect": false
	},
	"026": {
		"name": "King of Clubs",
		"suit": "clubs",
		"value": "K",
		"effect": false
	},
	"027": {
		"name": "Ace of Diamonds",
		"suit": "diamonds",
		"value": 1,
		"effect": true
	},
	"028": {
		"name": "Two of Diamonds",
		"suit": "diamonds",
		"value": 2,
		"effect": false
	},
	"029": {
		"name": "Three of Diamonds",
		"suit": "diamonds",
		"value": 3,
		"effect": false
	},
	"030": {
		"name": "Four of Diamonds",
		"suit": "diamonds",
		"value": 4,
		"effect": false
	},
	"031": {
		"name": "Five of Diamonds",
		"suit": "diamonds",
		"value": 5,
		"effect": false
	},
	"032": {
		"name": "Six of Diamonds",
		"suit": "diamonds",
		"value": 6,
		"effect": false
	},
	"033": {
		"name": "Seven of Diamonds",
		"suit": "diamonds",
		"value": 7,
		"effect": false
	},
	"034": {
		"name": "Eight of Diamonds",
		"suit": "diamonds",
		"value": 8,
		"effect": false
	},
	"035": {
		"name": "Nine of Diamonds",
		"suit": "diamonds",
		"value": 9,
		"effect": false
	},
	"036": {
		"name": "Ten of Diamonds",
		"suit": "diamonds",
		"value": 10,
		"effect": false
	},
	"037": {
		"name": "Jack of Diamonds",
		"suit": "diamonds",
		"value": "J",
		"effect": false
	},
	"038": {
		"name": "Queen of Diamonds",
		"suit": "diamonds",
		"value": "Q",
		"effect": false
	},
	"039": {
		"name": "King of Diamonds",
		"suit": "diamonds",
		"value": "K",
		"effect": false
	},
	"040": {
		"name": "Ace of Hearts",
		"suit": "hearts",
		"value": 1,
		"effect": true
	},
	"041": {
		"name": "Two of Hearts",
		"suit": "hearts",
		"value": 2,
		"effect": false
	},
	"042": {
		"name": "Three of Hearts",
		"suit": "hearts",
		"value": 3,
		"effect": false
	},
	"043": {
		"name": "Four of Hearts",
		"suit": "hearts",
		"value": 4,
		"effect": false
	},
	"044": {
		"name": "Five of Hearts",
		"suit": "hearts",
		"value": 5,
		"effect": false
	},
	"045": {
		"name": "Six of Hearts",
		"suit": "hearts",
		"value": 6,
		"effect": false
	},
	"046": {
		"name": "Seven of Hearts",
		"suit": "hearts",
		"value": 7,
		"effect": false
	},
	"047": {
		"name": "Eight of Hearts",
		"suit": "hearts",
		"value": 8,
		"effect": false
	},
	"048": {
		"name": "Nine of Hearts",
		"suit": "hearts",
		"value": 9,
		"effect": false
	},
	"049": {
		"name": "Ten of Hearts",
		"suit": "hearts",
		"value": 10,
		"effect": false
	},
	"050": {
		"name": "Jack of Hearts",
		"suit": "hearts",
		"value": "J",
		"effect": false
	},
	"051": {
		"name": "Queen of Hearts",
		"suit": "hearts",
		"value": "Q",
		"effect": false
	},
	"052": {
		"name": "King of Hearts",
		"suit": "hearts",
		"value": "K",
		"effect": false
	},
	"053": {
		"name": "Eleven of Spades",
		"suit": "spades",
		"value": 11,
		"effect": false
	},
	"054": {
		"name": "Twelve of Spades",
		"suit": "spades",
		"value": 12,
		"effect": false
	},
	"055": {
		"name": "Thirteen of Spades",
		"suit": "spades",
		"value": 13,
		"effect": false
	},
	"056": {
		"name": "Eleven of Clubs",
		"suit": "clubs",
		"value": 11,
		"effect": false
	},
	"057": {
		"name": "Twelve of Clubs",
		"suit": "clubs",
		"value": 12,
		"effect": false
	},
	"058": {
		"name": "Thirteen of Clubs",
		"suit": "clubs",
		"value": 13,
		"effect": false
	},
	"059": {
		"name": "Eleven of Diamonds",
		"suit": "diamonds",
		"value": 11,
		"effect": false
	},
	"060": {
		"name": "Twelve of Diamonds",
		"suit": "diamonds",
		"value": 12,
		"effect": false
	},
	"061": {
		"name": "Thirteen of Diamonds",
		"suit": "diamonds",
		"value": 13,
		"effect": false
	},
	"062": {
		"name": "Eleven of Hearts",
		"suit": "hearts",
		"value": 11,
		"effect": false
	},
	"063": {
		"name": "Twelve of Hearts",
		"suit": "hearts",
		"value": 12,
		"effect": false
	},
	"064": {
		"name": "Thirteen of Hearts",
		"suit": "hearts",
		"value": 13,
		"effect": false
	},
	"065": {
		"name": "Twenty One of Spades",
		"suit": "spades",
		"value": 21,
		"effect": false
	},
	"066": {
		"name": "Twenty One of Clubs",
		"suit": "clubs",
		"value": 21,
		"effect": false
	},
	"067": {
		"name": "Twenty One of Diamonds",
		"suit": "diamonds",
		"value": 21,
		"effect": false
	},
	"068": {
		"name": "Twenty One of Hearts",
		"suit": "hearts",
		"value": 21,
		"effect": false
	},
	"069": {
		"name": "Joker",
		"suit": "special",
		"value": "Joker",
		"effect": false
	},
	"070": {
		"name": "Birthday Card",
		"suit": "special",
		"value": 0,
		"effect": true
	},
	"071": {
		"name": "Magic Trick Card",
		"suit": "special",
		"value": 0,
		"effect": true
	}
}
