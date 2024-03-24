extends Node3D
signal masterpasswordset()



func _on_door_manager_masterpasswordset(value):
	masterpasswordset.emit(value)
