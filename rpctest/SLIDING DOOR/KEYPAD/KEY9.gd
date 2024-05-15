extends AnimatableBody3D
func _clicked():
	$"../..".lastpressed = "9"
	$"../AnimationPlayer".play("9 PRESSED")
