extends AnimatableBody2D

var speed = 1
var active = 1
var keys = ["l","j","k","i"]
var set_key = ""
var actionable = 1
var test = Vector2(0,0)
signal set_label
signal killed

func _init():
	set_key= keys.pick_random()
	
	if set_key == "l":
		test = Vector2(200,0)
	if set_key == "k":
		test = Vector2(0,200)
	if set_key == "j":
		test = Vector2(-200,0)
	if set_key == "i":
		test = Vector2(0,-200)

func _ready():
	for i in get_parent().get_children():
		if i.has(set_key):
			var children = []
			children.append(i.set_key)
			var seen = {}
			seen[children[0]] = true
			for s in range(1, children.size()):
				print(children[s])
				var v = children[s]
				if seen.has(v):
					queue_free()
	get_parent().stop.connect(self._on_control_center_stop)
	get_parent().start.connect(self._on_control_center_start)
	if set_key == "l":
		speed = get_parent().speed * -1
	if set_key == "k":
		speed = get_parent().speed * -1
	if set_key == "j":
		speed = get_parent().speed
	if set_key == "i":
		speed = get_parent().speed
	set_label.emit(set_key)
	

func _physics_process(_delta):
	
	if active == 1:
		if set_key == "l" or set_key == "j":
			position += Vector2(speed,0)
		elif set_key == "i" or set_key == "k":
			position += Vector2(0,speed)
	if Input.is_action_just_pressed(set_key):
		if actionable == 1:
			killed.emit(1)
			print("dead")
			queue_free()


func _on_control_center_stop(v):
	active = 0



func _on_control_center_start(v):
	active = 1
