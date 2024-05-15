extends Node3D

signal HUDUPDATE
func _on_sliding_door_masterpasswordset(value):
	HUDUPDATE.emit(value)


func _on_sliding_door_updatepda(value):
	HUDUPDATE.emit(value)


func _on_sliding_door_2_masterpasswordset(value):
	HUDUPDATE.emit(value)


func _on_sliding_door_2_updatepda(value):
	HUDUPDATE.emit(value)

func _ready():
	var a = $".".name
	$AudioManager.setupAudio(a)

