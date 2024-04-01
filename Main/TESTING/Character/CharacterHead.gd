extends MeshInstance3D

# accumulators
var rot_x = 0
var rot_y = 0
var sensitivity := 0.005


#CAMERA CONTROLS
func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# modify accumulated mouse rotation
		rot_x += event.relative.x * sensitivity
		rot_y += event.relative.y * sensitivity
		rot_y = clamp(rot_y, deg_to_rad(10), deg_to_rad(165))
		transform.basis = Basis() # reset rotation
		#rotate_object_local(Vector3(0, 1, 0), -rot_x) # first rotate in Y
		rotate_object_local(Vector3(1, 0, 0), -rot_y) # then rotate in X
