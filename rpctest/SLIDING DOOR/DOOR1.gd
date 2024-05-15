extends AnimatableBody3D
func _clicked():
	if $"../DOOR MANAGER".finished == 1:
		if $"../DOOR MANAGER".state == "CLOSED":
			$"../AnimationPlayer".play("OPEN")
			$"../DOOR MANAGER".finished = 0
			$"../DOOR MANAGER".state = "OPEN"
		elif $"../DOOR MANAGER".state == "OPEN":
			$"../AnimationPlayer".play("CLOSE")
			$"../DOOR MANAGER".finished = 0
			$"../DOOR MANAGER".state = "CLOSED"
