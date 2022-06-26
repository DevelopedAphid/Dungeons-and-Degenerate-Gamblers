extends Node2D

signal spin_completed

var is_spinning = false
var winding_down = false
var random_number = 0
var wheel_frame = 0
var spins = 0

func _ready():
	spin_the_wheel()

func _physics_process(_delta):
	if is_spinning:
		wheel_frame += 1
		if wheel_frame > 19:
			wheel_frame = 0
			spins += 1
		$WheelSprite.frame = wheel_frame
		if spins > 3:
			is_spinning = false
			winding_down = true
	if winding_down:
		wheel_frame += 1
		if wheel_frame == random_number:
			winding_down = false
			emit_signal("spin_completed")
		$WheelSprite.frame = wheel_frame

func spin_the_wheel():
	random_number = round(rand_range(0, 19))
	is_spinning = true
