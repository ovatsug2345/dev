extends AnimatableBody3D
func _clicked():
	$"../..".lastpressed = "3"
	$"../AnimationPlayer".play("3 PRESSED")
