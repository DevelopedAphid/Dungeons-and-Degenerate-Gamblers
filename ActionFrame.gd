extends Line2D

var grid_size: int = 32
var action_frame_resolution: Vector2
var action_frame_offset: Vector2



func _ready():
	action_frame_resolution = get_parent().action_frame_resolution
	action_frame_offset = get_parent().action_frame_offset
	
	add_point(Vector2(action_frame_offset.x, action_frame_offset.y))
	add_point(Vector2(action_frame_offset.x, action_frame_resolution.y + action_frame_offset.y))
	add_point(Vector2(action_frame_resolution.x + action_frame_offset.x, action_frame_resolution.y + action_frame_offset.y))
	add_point(Vector2(action_frame_resolution.x + action_frame_offset.x, action_frame_offset.y))
	add_point(Vector2(action_frame_offset.x, action_frame_offset.y))
	
	get_node("Character").position = Vector2(action_frame_offset.x+grid_size/2, action_frame_offset.y+grid_size/2)

func snap_vector_to_grid(vector: Vector2) -> Vector2:
	var vector_from_top_left: Vector2 = vector - action_frame_offset
	vector_from_top_left.x = stepify(vector_from_top_left.x + action_frame_offset.x, grid_size)
	vector_from_top_left.y = stepify(vector_from_top_left.y + action_frame_offset.y, grid_size)
	return vector_from_top_left

