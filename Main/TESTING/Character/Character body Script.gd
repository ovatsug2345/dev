extends CharacterBody3D


const BASE_SPEED = 5.0
const JUMP_VELOCITY = 4.5
var SPEED = 5
var SPRINTING := true
var SPRINTING_MODIFIER := 2
var sensitivity := 0.005
# accumulators
var rot_x = 0
var rot_y = 0

#CAMERA CONTROLS
func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# modify accumulated mouse rotation
		rot_x += event.relative.x * sensitivity
		rot_y += event.relative.y * sensitivity
		rot_y = clamp(rot_y, deg_to_rad(-80), deg_to_rad(75))
		transform.basis = Basis() # reset rotation
		rotate_object_local(Vector3(0, 1, 0), -rot_x) # first rotate in Y
		rotate_object_local(Vector3(1, 0, 0), -rot_y) # then rotate in X

	
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(_delta):
	var space_state = get_world_3d().direct_space_state
	var cam = $CharacterHead/Camera3D
	var mousepos = get_viewport().get_mouse_position()
	const RAY_LENGTH = 1000
	var origin = cam.project_ray_origin(mousepos)
	var end = origin + cam.project_ray_normal(mousepos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	move_and_slide()
	var _result = space_state.intersect_ray(query)
	
	# GRAVITY
	if not is_on_floor():
		velocity.y -= gravity * _delta

	# JUMP ACTION
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	#SPRINT ACTION
	if Input.is_action_pressed("Sprint"):
		SPEED = BASE_SPEED * SPRINTING_MODIFIER
		
	else: SPEED = BASE_SPEED
	
		
	# MOVEMENT
	var input_dir = Input.get_vector("MOVELEFT", "MOVERIGHT", "MOVEFORWARD", "MOVEBACKWARDS")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	#PDA ACTION
func _unhandled_input(_InputEvent):
	if !Input.is_action_pressed("PDA"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	
