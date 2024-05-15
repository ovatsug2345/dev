extends AnimatableBody3D
func _clicked():
	$"../..".lastpressed = "1"
	$"../AnimationPlayer".play("1 PRESSED")
