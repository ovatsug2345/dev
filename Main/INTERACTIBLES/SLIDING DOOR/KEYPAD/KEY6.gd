extends AnimatableBody3D
func _clicked():
	$"../..".lastpressed = "6"
	$"../AnimationPlayer".play("6 PRESSED")
