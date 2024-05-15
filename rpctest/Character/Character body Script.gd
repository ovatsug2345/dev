extends CharacterBody3D

@export var ownCamera : Node3D

const BASE_SPEED = 5.0
const JUMP_VELOCITY = 4.5
var SPEED = 5
var SPRINTING := false
var SPRINTING_MODIFIER := 2




@export var player := 1 :
	set(id):
		player = id
		$InputSynchronizer.set_multiplayer_authority(id)
		
@onready var input = $InputSynchronizer

		
		

func _ready():
	if player == multiplayer.get_unique_id():
		$CharacterHead/Camera3D.current = true



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(_delta):
	#camera controls
	if input.rot_x != 0 or input.rot_y != 0:
		transform.basis = Basis() # reset rotation
		rotate_object_local(Vector3(0, 1, 0), -input.rot_x) # first rotate in Y
		rotate_object_local(Vector3(1, 0, 0), -input.rot_y) # then rotate in X
		
		
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
	if input.jumping and is_on_floor():
		velocity.y = JUMP_VELOCITY
	input.jumping = false
	
	#SPRINT ACTION
	if input.sprinting:
		SPEED = BASE_SPEED * SPRINTING_MODIFIER
		
	else: SPEED = BASE_SPEED
	
		
	# MOVEMENT
	
	var direction = (transform.basis * Vector3(input.direction.x, 0, input.direction.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	#PDA ACTION
	if !Input.is_action_pressed("PDA"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	
