extends AnimatableBody3D
func _clicked():
	$"../..".lastpressed = "0"
	$"../AnimationPlayer".play("0 PRESSED")
