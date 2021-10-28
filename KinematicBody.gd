extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if Input.is_action_just_released("forward"):
		move_and_slide(Vector3(1,1,1),Vector3(1,1,1),false,4,0,false)
