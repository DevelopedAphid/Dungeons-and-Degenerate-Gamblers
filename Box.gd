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
	table.clear_table()
