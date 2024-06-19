extends CanvasLayer
@export var minigameFolder = "res://Hacking Minigame/"
var minigames = []
var hackGame
var currentHack 
var hacking = false

func _on_character_hudupdate(value):
	print(value)
	$PASSWORD.text = str(value)

func start_hack(reward):
	load_multiple(minigameFolder)
	var selectedMinigame = minigameFolder + minigames.pick_random()
	var game = load(selectedMinigame).instantiate()
	add_child(game)
	hackGame=game
	currentHack = reward
	hacking = true


func cancelMinigame():
	if hacking == true:
		hackGame.quit()
	
func load_multiple(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			else:
				if file_name.ends_with(".tscn"):
					minigames.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
		
func win():
	hacking = false
	$PASSWORD.text = str(currentHack)
