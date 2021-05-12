extends Line2D

var grid_size: int
var action_frame_resolution: Vector2
var action_frame_offset: Vector2

func _ready():
	grid_size = get_parent().grid_size
	action_frame_resolution = get_parent().get_parent().action_frame_resolution
	action_frame_offset = get_parent().get_parent().action_frame_offset
	
	add_point(Vector2(action_frame_offset.x,action_frame_offset.y))
	var x = action_frame_offset.x
	var y = action_frame_offset.y
	
	for n in range(action_frame_offset.x, action_frame_resolution.x + grid_size, grid_size):
		add_point(Vector2(x,action_frame_offset.y))
		add_point(Vector2(x,action_frame_resolution.y+action_frame_offset.y))
		add_point(Vector2(x,action_frame_offset.y))
		x = n
	
	for n in range(action_frame_offset.y, action_frame_resolution.y + grid_size, grid_size):
		add_point(Vector2(action_frame_offset.x,y))
		add_point(Vector2(action_frame_resolution.x+action_frame_offset.x,y))
		add_point(Vector2(action_frame_offset.x,y))
		y = n

