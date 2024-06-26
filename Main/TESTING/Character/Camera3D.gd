extends Camera3D


var mouse_pos = Vector2()
func _input(event):
	if event is InputEventMouse:
		mouse_pos = event.position
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			get_selection()
			
			
func get_selection():
	var worldspace = get_world_3d().direct_space_state
	var start =project_ray_origin(mouse_pos)
	var end = project_position(mouse_pos, 1000)
	var result = worldspace.intersect_ray(PhysicsRayQueryParameters3D.create(start, end))
	print(result)
	if result and result.collider.has_method("_clicked"):
		result.collider._clicked()
	
