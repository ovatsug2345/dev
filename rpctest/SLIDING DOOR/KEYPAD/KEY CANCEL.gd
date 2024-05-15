extends AnimatableBody3D
func _clicked():
	$"../..".password.clear()
	$"../AnimationPlayer".play("CANCEL PRESSED")
