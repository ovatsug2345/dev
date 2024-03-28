extends Node

var prompt_spawn = 0
var game_started = 0
var prompts_ready = 0

var end_of_line = 0

var prompt_options = []
var prompts_path = "res://Hacking Minigame/Prompts/"


signal start
signal stop

func _process(_delta):
	if Input.is_action_just_pressed("Sprint") and prompts_ready == 1:
		start.emit(ready)
		game_started = 1
		start_spawning()

func start_spawning():
	while game_started == 1:
		spawn_prompt()
		await get_tree().create_timer(1.0).timeout

func spawn_prompt():
	var r_prompt =prompts_path + prompt_options.pick_random()
	var random_prompt = load(r_prompt).instantiate()
	random_prompt.speed = -5
	random_prompt.position = prompt_spawn
	add_child(random_prompt)


func _on_detection_area_s_detection_area_xy(val):
		prompt_spawn = val + Vector2(600,0)
		

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


func _on_area_2d_body_exited(body):
	if end_of_line == body:
		stop.emit()
		game_started = 0


func _on_area_2d_2_body_entered(body):
	end_of_line = body
	
