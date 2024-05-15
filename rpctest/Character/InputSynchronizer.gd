extends MultiplayerSynchronizer


@export var jumping := false
@export var sprinting := false
@export var direction := Vector2()


# accumulators
var rot_x = 0
var rot_y = 0
var sensitivity := 0.005


@rpc("call_local")
func jump():
	jumping = true
	
	
@rpc("call_local")
func sprinton():
	sprinting = true
@rpc("call_local")
func sprintoff():
	sprinting = false
	
var focused := true

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			focused = false
		NOTIFICATION_APPLICATION_FOCUS_IN:
			focused = true
			
func _process(delta):
	if focused:
		direction = Input.get_vector("MOVELEFT","MOVERIGHT","MOVEFORWARD","MOVEBACKWARDS")
		if Input.is_action_just_pressed("ui_accept"):
			jump.rpc()
		if Input.is_action_just_pressed("Sprint"):
			sprinton.rpc()
		if Input.is_action_just_released("Sprint"):
			sprintoff.rpc()
	
#CAMERA CONTROLS
func _input(event):
	if focused:
		if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			# modify accumulated mouse rotation
			rot_x += event.relative.x * sensitivity
			rot_y += event.relative.y * sensitivity
			rot_y = clamp(rot_y, deg_to_rad(10), deg_to_rad(165))
