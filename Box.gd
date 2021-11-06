extends RigidBody

var material
var mesh_instance

func interact():
	mesh_instance = get_node("MeshInstance")
	material = mesh_instance.get_surface_material(0)
	if material.albedo_color == Color(0.0, 1.0, 0.0):
		material.albedo_color = Color(1.0, 0.0, 0.0)
	else:
		material.albedo_color = Color(0.0, 1.0, 0.0)
	
	mesh_instance.set_surface_material(0,material)
	
	var table = get_parent().get_node("Table")
	for n in table.get_children():
		if n.is_in_group("Cards"):
			table.remove_child(n)
			n.queue_free()
	
	table.card_spawn_position = table.DEFAULT_CARD_SPAWN_POSITION
