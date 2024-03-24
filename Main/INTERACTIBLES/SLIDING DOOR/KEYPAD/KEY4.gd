extends AnimatableBody3D
func _clicked():
	$"../..".lastpressed = "4"
	$"../AnimationPlayer".play("4 PRESSED")
