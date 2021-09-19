extends Sprite

var move_step: int
var is_moving: bool
var last_dir_moved: String = "left"

signal character_level_up(level)

func _ready():
	move_step = get_parent().grid_size

func _on_GUI_character_moved():
	if last_dir_moved == "left":
		position += Vector2(0,move_step)
		last_dir_moved = "down"
	elif last_dir_moved == "down":
		position += Vector2(move_step,0)
		last_dir_moved = "right"
	elif last_dir_moved == "right":
		position += Vector2(0,-move_step)
		last_dir_moved = "up"
	elif last_dir_moved == "up":
		position += Vector2(-move_step,0)
		last_dir_moved = "left"
