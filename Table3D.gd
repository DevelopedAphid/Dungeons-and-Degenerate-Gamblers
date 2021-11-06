extends RigidBody

var card_spawn_position

const DEFAULT_CARD_SPAWN_POSITION = Vector3(0,0.9,0.5)

func _ready():
	card_spawn_position = DEFAULT_CARD_SPAWN_POSITION

func interact():
	var new_card = load("res://Card3D.tscn")
	var card_instance = new_card.instance()
	card_instance.add_to_group("Interactable")
	card_instance.add_to_group("Cards")
	add_child(card_instance)
	
	card_instance.translate_object_local(card_spawn_position)
	card_spawn_position.z = card_spawn_position.z - 0.1
