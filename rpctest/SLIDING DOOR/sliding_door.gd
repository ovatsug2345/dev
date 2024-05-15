extends Node3D

signal masterpasswordset()
signal updatepda()


func _on_door_manager_masterpasswordset(value):
	masterpasswordset.emit(value)


func _on_keypad_updatepda(value):
	updatepda.emit(value)
