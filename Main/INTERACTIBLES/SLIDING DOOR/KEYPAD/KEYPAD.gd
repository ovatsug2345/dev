extends Node3D
var lastpressed = "none"
var password = []
var doorfinished = 1
var dooropen = 0


signal doorcheck()
signal doorreply()
signal opendoor()
signal masterpasswordset()

func _physics_process(_delta):
	if lastpressed == "none":
			pass
	else:
		password.append(lastpressed)
		lastpressed = "none"
		if len(password) <= 4:
			print(password)
		else:
			password.clear()


func _on_door_manager_doorfinished(value):
	doorfinished = value

func _on_key_confirm_doorcheck(value):
	doorcheck.emit(value)

func _on_door_manager_doorreply(value):
	doorreply.emit(value)

func _on_key_confirm_opendoor(value):
	opendoor.emit(value)


func _on_sliding_door_masterpasswordset(value):
	masterpasswordset.emit(value)
