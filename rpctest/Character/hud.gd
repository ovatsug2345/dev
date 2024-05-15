extends CanvasLayer


func _on_character_hudupdate(value):
	print(value)
	$PASSWORD.text = str(value)
