extends CanvasLayer


func _on_character_hudupdate(value):
	$PASSWORD.text = str(value)
