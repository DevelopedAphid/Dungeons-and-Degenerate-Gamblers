extends KinematicBody

var dir
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if Input.is_action_pressed("movement_forward"):
		move_and_slide(Vector3(1,1,1),Vector3(1,1,1),false,4,0,false)

func process_input(delta):
	dir = Vector3()
	var dir_2d = Vector2()
	
	if Input.is_action_pressed("movement_forward"):
		dir_2d.x += 1
	if Input.is_action_pressed("movement_backward"):
		dir_2d.x -= 1
	if Input.is_action_pressed("movement_right"):
		dir_2d.y += 1
	if Input.is_action_pressed("movement_left"):
		dir_2d.y -= 1
	
	
