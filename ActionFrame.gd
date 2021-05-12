extends Line2D

var grid_size: int = 32


func _ready():
	var action_frame_resolution: Vector2 = get_parent().action_frame_resolution
	var action_frame_offset: Vector2 = get_parent().action_frame_offset
	
	add_point(Vector2(action_frame_offset.x, action_frame_offset.y))
	add_point(Vector2(action_frame_offset.x, action_frame_resolution.y + action_frame_offset.y))
	add_point(Vector2(action_frame_resolution.x + action_frame_offset.x, action_frame_resolution.y + action_frame_offset.y))
	add_point(Vector2(action_frame_resolution.x + action_frame_offset.x, action_frame_offset.y))
	add_point(Vector2(action_frame_offset.x, action_frame_offset.y))
	
	get_node("Character").position = Vector2(action_frame_offset.x+grid_size/2, action_frame_offset.y+grid_size/2)


