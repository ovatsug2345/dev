extends AnimatableBody2D


var unique_id
var speed = 1
var active = 1
var keys = ["l","j","k","i"]
var set_key = ""
var actionable = 1
var test = Vector2(0,0)


signal set_label
signal killed


func _init():
	self.visible = false
	set_key = keys.pick_random()
	
	if set_key == "l":
		test = Vector2(200,0)
	if set_key == "k":
		test = Vector2(0,200)
	if set_key == "j":
		test = Vector2(-200,0)
	if set_key == "i":
		test = Vector2(0,-200)


func _ready():
	#print("I'm " + str(set_key))
	unique_id = randi()
	for i in self.get_parent().get_children():
		var prop = i.get_property_list()
		#print("NEWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW")
		for p in prop:
			if p.name == "set_key":
				#print(str(i.unique_id) + str(i.set_key))
				#print(str(i.set_key) + str(i.unique_id) + str(set_key) + str(unique_id))
				if i.set_key == set_key and i.unique_id != unique_id:
					#print("kill")
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
	self.visible = true
	if active == 1:
		if set_key == "l" or set_key == "j":
			position += Vector2(speed,0)
		elif set_key == "i" or set_key == "k":
			position += Vector2(0,speed)
	if Input.is_action_just_pressed(set_key):
		if actionable == 1:
			killed.emit(1)
			#print("dead")
			queue_free()


func _on_control_center_stop(_v):
	active = 0


func _on_control_center_start(_v):
	active = 1
