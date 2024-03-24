extends Node
var state = "CLOSED"
var finished = 1
var masterpassword = randi_range(100,999)
signal doorfinished()
signal doorreply()
signal masterpasswordset()

func _physics_process(delta):
	pass

func _ready():
	masterpasswordset.emit(masterpassword)

func _on_animation_player_animation_finished(anim_name):
	finished = 1
	doorfinished.emit(1)

func _on_keypad_doorcheck(value):
	if finished == 1:
		doorreply.emit($".".state)


func _on_keypad_opendoor(value):
	if value == 0:
		$"../AnimationPlayer".play("OPEN")
		state = "OPEN"
		finished = 0
	elif value == 1:
		$"../AnimationPlayer".play("CLOSE")
		state = "CLOSED"
		finished = 0
		
		
