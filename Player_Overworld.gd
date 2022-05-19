extends KinematicBody2D

var walk_speed = 50
var direction_vector = Vector2(0, 0)
var facing_left = true

var player_sprite_left = preload("res://assets/art/characters/player1.png")
var player_sprite_right = preload("res://assets/art/characters/player2.png")

func _ready():
	position = PlayerSettings.player_position
	PlayerSettings.player_sprite = player_sprite_left

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
	
	var _collision = move_and_collide(direction_vector * walk_speed * delta)
	PlayerSettings.player_position = position
	
	if Input.get_action_strength("ui_left") > Input.get_action_strength("ui_right"):
		facing_left = true
		$Sprite.texture = player_sprite_left
		$InteractionArea.scale.x = 1
	elif Input.get_action_strength("ui_right") > Input.get_action_strength("ui_left"):
		facing_left = false
		$Sprite.texture = player_sprite_right
		$InteractionArea.scale.x = -1
	
	if Input.is_action_just_pressed("ui_accept"):
		var areas = $InteractionArea.get_overlapping_areas()
		if areas.size() > 0:
			for area in areas:
				area.get_parent().interact()
	
