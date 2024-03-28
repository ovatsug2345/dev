extends AnimatableBody2D

var speed = 1
var active = 1
var keys = ["h","j","k","i"]
var set_key = ""
var actionable = 0
signal set_label

func _ready():
	get_parent().stop.connect(self._on_control_center_stop)
	set_key= keys.pick_random()
	set_label.emit(set_key)

func _physics_process(_delta):
	print(set_key)
	if active == 1:
		position += Vector2(speed,0)
	if Input.is_action_just_pressed(set_key):
		if actionable == 1:
			queue_free()


func _on_control_center_stop():
	active = 0
