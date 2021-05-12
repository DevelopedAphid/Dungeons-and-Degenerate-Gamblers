extends Line2D


func _ready():
	var action_frame_resolution: Vector2 = get_parent().action_frame_resolution
	var action_frame_offset: Vector2 = get_parent().action_frame_offset
	
	add_point(Vector2(action_frame_offset.x, action_frame_offset.y))
	add_point(Vector2(action_frame_offset.x, action_frame_resolution.y + action_frame_offset.y))
	add_point(Vector2(action_frame_resolution.x + action_frame_offset.x, action_frame_resolution.y + action_frame_offset.y))
	add_point(Vector2(action_frame_resolution.x + action_frame_offset.x, action_frame_offset.y))
	add_point(Vector2(action_frame_offset.x, action_frame_offset.y))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
