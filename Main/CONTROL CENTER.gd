extends Control

var prompt_spawn 
var game_started = false
var prompts_ready = 0
var detection_area
var speed = 3
var prompt_count = 0
var finished = true
var end_of_line = 0
var prompt_options = []
var prompts_path = "res://Hacking Minigame/Prompts/"


signal start
signal stop
signal restart
signal score_area


func _process(_delta):
	if Input.is_action_just_pressed("Sprint") and prompts_ready == 1:
		start.emit(ready)
		start_spawning()

func start_spawning():
	if finished == true:
		finished = false
		game_started = true
		while game_started == true:
			spawn_prompt()
			await get_tree().create_timer(1.0).timeout
			finished = true


func spawn_prompt():
	var r_prompt =prompts_path + prompt_options.pick_random()
	var random_prompt = load(r_prompt).instantiate()
	random_prompt.position =self.position + random_prompt.spawn_pos
	add_child(random_prompt)
	random_prompt.killed.connect(self._on_prompt_killed)


func _on_detection_area_s_detection_area_xy(val):
		detection_area = val


func _ready():
	load_prompts(prompts_path)
	if prompt_options.size() >= 1:
		prompts_ready = 1


func load_prompts(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			else:
				if file_name.ends_with(".tscn"):
					prompt_options.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")


func _on_area_2d_2_body_entered(_body):
	stop.emit(1)
	game_started = false


func _on_prompt_killed(_v):
	if finished == true:
		start_spawning()
		start.emit(1)
	else:
		if game_started == false:
			while game_started == false:
				if finished == true:
					start_spawning()
					start.emit(1)


func _on_area_2d_body_entered(body):
	score_area.emit(body)
