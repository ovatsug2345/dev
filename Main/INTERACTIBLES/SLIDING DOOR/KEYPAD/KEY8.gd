extends AnimatableBody3D
func _clicked():
	$"../..".lastpressed = "8"
	$"../AnimationPlayer".play("8 PRESSED")
