extends RigidBody

var animation_player
var start_time

func _ready():
	randomize()
	animation_player = $AnimationPlayer
	
	start_time = rand_range(0.0, animation_player.current_animation_length)
	animation_player.advance(start_time)
	animation_player.playback_speed = rand_range(0.5, 1.5)
