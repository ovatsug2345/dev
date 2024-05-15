extends VBoxContainer
var active_players = []
var active_player_labels = []
signal player_connected

func _ready():
	active_players = $"..".players
	print(active_players)
	for i in $"..".players:
		print(i)
		var player_label = Label.new()
		player_label.set_vertical_alignment(VERTICAL_ALIGNMENT_CENTER)
		player_label.set_horizontal_alignment(HORIZONTAL_ALIGNMENT_CENTER)
		player_label.text = $"..".players[i]
		player_label.name = $"..".players[i]
		print($"..".players)
		add_child(player_label)
		print(player_label.name)
	


func _on_control_player_connected(peer_id, player_info):
	print(str(peer_id) + str(player_info))
	active_players[peer_id] = player_info
	print(active_players)
	var player_label = Label.new()
	player_label.set_vertical_alignment(VERTICAL_ALIGNMENT_CENTER)
	player_label.set_horizontal_alignment(HORIZONTAL_ALIGNMENT_CENTER)
	player_label.text = player_info["name"]
	add_child(player_label)
	$".".visible = true
	player_connected.emit()
	


func _on_control_player_disconnected(peer_id):
	print(peer_id)
	active_players[str(peer_id)].queue_free()
	active_players.erase(peer_id)
	
