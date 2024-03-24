extends AnimatableBody3D

var c = ""
var doorpassword = "2214"
var masterpassword = ""

signal doorcheck()
signal opendoor()

func _clicked():
	c = ""
	print(masterpassword)
	for i in $"../..".password:
		c += String(i)
	if c == masterpassword or c == doorpassword:
		print("correct")
		doorcheck.emit(1)
	$"../AnimationPlayer".play("CONFIRM PRESSED")
	
	


func _on_keypad_doorreply(value):
	if value == "CLOSED":
		opendoor.emit(0)
	elif value == "OPEN":
		opendoor.emit(1)


func _on_keypad_masterpasswordset(value):
	masterpassword = str(value)
