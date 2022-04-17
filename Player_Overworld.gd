extends KinematicBody2D

var walk_speed = 50
var direction_vector = Vector2(0, 0)
var facing_left = true

func _physics_process(delta):
	direction_vector = Vector2(0, 0)
	if Input.get_action_strength("ui_up"):
		direction_vector.y = -1
	if Input.get_action_strength("ui_down"):
		direction_vector.y = 1
	if Input.get_action_strength("ui_left"):
		direction_vector.x = -1
	if Input.get_action_strength("ui_right"):
		direction_vector.x = 1
	
	var collision = move_and_collide(direction_vector * walk_speed * delta)
	if collision:
		print("collided")
	
	if Input.get_action_strength("ui_left") > Input.get_action_strength("ui_right"):
		facing_left = true
		$Sprite.flip_h = false
	elif Input.get_action_strength("ui_right") > Input.get_action_strength("ui_left"):
		facing_left = false
		$Sprite.flip_h = true
	
	if Input.is_action_just_pressed("ui_accept"):
		var areas = $InteractionArea.get_overlapping_areas()
		if areas.size() > 0:
			for area in areas:
				area.get_parent().interact()
	
