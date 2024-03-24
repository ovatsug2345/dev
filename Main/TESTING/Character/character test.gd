extends Node3D

signal HUDUPDATE
func _on_sliding_door_masterpasswordset(value):
	HUDUPDATE.emit(value)
