extends AnimatableBody3D
func _clicked():
	$"../..".lastpressed = "2"
	$"../AnimationPlayer".play("2 PRESSED")
