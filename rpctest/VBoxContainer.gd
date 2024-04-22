extends VBoxContainer

func _ready():
	for i in $"..".players:
		print(i)
		var player_label = Label.new()
		player_label.set_vertical_alignment(VERTICAL_ALIGNMENT_CENTER)
		player_label.set_horizontal_alignment(HORIZONTAL_ALIGNMENT_CENTER)
		player_label.text = $"..".players[i]
		print($"..".players)
		add_child(player_label)
