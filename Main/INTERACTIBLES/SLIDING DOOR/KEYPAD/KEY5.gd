extends AnimatableBody3D
func _clicked():
	$"../..".lastpressed = "5"
	$"../AnimationPlayer".play("5 PRESSED")
