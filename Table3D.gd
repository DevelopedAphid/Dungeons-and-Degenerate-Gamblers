extends RigidBody

var card_spawn_position

const DEFAULT_CARD_SPAWN_POSITION = Vector3(0,0.9,0.5)

func _ready():
	card_spawn_position = DEFAULT_CARD_SPAWN_POSITION
	
	#deal player suit choice cards
	deal_card_at_position(add_new_card("001"), card_spawn_position)
	deal_card_at_position(add_new_card("014"), card_spawn_position - Vector3(0,0,0.1))
	deal_card_at_position(add_new_card("027"), card_spawn_position - Vector3(0,0,0.2))
	deal_card_at_position(add_new_card("040"), card_spawn_position - Vector3(0,0,0.3))

func interact():
	var card_instance = add_new_card("001")
	deal_card_at_position(card_instance, card_spawn_position)
	card_spawn_position.z = card_spawn_position.z - 0.1

func deal_card_at_position(card, position):
	card.translate_object_local(position)

func add_new_card(id) -> Object:
	var Card = load("res://Card3D.tscn")
	var card_instance = Card.instance()
	add_child(card_instance)
	card_instance.add_to_group("Interactable")
	card_instance.add_to_group("Cards")
	card_instance.set_card_id(id)
	
	return card_instance

func clear_table():
	for n in get_children():
		if n.is_in_group("Cards"):
			remove_child(n)
			n.queue_free()
	
	card_spawn_position = DEFAULT_CARD_SPAWN_POSITION
