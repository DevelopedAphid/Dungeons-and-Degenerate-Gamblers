extends RayCast

func _process(_delta):
	var collider = get_collider()
	
	if is_colliding():
		if Input.is_action_just_pressed("interact"):
			if collider.is_in_group("Interactable"):
				collider.interact()
