extends AnimatableBody3D
func _clicked():
	$"../..".lastpressed = "7"
	$"../AnimationPlayer".play("7 PRESSED")
