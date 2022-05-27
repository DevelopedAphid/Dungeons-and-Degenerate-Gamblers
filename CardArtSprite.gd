extends Sprite

onready var card = get_parent()

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if get_rect().has_point(to_local(event.position)):
			get_parent().sprite_clicked()

func activate_burn_shader():
	if not card.is_inside_tree():
		yield(card, "ready")
	material.set_shader_param("duration", 2.0)
	material.set_shader_param("start_time", OS.get_ticks_msec() / 1000.0 - 2)
	var burn_timer = Timer.new()
	add_child(burn_timer)
	burn_timer.wait_time = 1.0
	burn_timer.one_shot = true
	burn_timer.connect("timeout", get_parent(), "on_burn_timer_ended")
	burn_timer.start()
