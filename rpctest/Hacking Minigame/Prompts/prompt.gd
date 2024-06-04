extends AnimatableBody2D


var unique_id
var speed = 1
var active = 1
var keys = ["l","j","k","i"]
var set_key = ""
var actionable = 1
var spawn_pos = Vector2(0,0)
var score_value = -1


signal set_label
signal killed
signal end_game


func _init():
	self.visible = false
	set_key = keys.pick_random()
	
	if set_key == "l":
		spawn_pos = Vector2(300,0)
	if set_key == "k":
		spawn_pos = Vector2(0,300)
	if set_key == "j":
		spawn_pos = Vector2(-300,0)
	if set_key == "i":
		spawn_pos = Vector2(0,-300)


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
	get_parent().score_area.connect(self._on_score_area)
	var ran_speed = 1 #randf_range(1,2)
	if set_key == "l":
		speed = get_parent().speed * -1  * ran_speed
	if set_key == "k":
		speed = get_parent().speed * -1 * ran_speed
	if set_key == "j":
		speed = get_parent().speed * ran_speed
	if set_key == "i":
		speed = get_parent().speed * ran_speed
	set_label.emit(set_key)


func _process(_delta):
		if Input.is_action_just_pressed(set_key):
			if actionable == 1:
				killed.emit(1)
				Global.hack_score += score_value
				print(Global.hack_score)
				queue_free()


func _physics_process(_delta):
	
	self.visible = true
	
	if active == 1:
		if set_key == "l" or set_key == "j":
			position += Vector2(speed,0)
			await get_tree().create_timer(1000).timeout
		elif set_key == "i" or set_key == "k":
			position += Vector2(0,speed)
			await get_tree().create_timer(1000).timeout


func _on_control_center_stop(_v):
	active = 0


func _on_control_center_start(_v):
	active = 1


func _on_score_area(body):
	if body.unique_id == unique_id:
		score_value *= -1
		$Label.add_theme_color_override("font_color", Color.GREEN)
