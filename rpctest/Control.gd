extends Control

# Autoload named Lobby

# These signals can be connected to by a UI lobby scene or the game scene.
signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected

const PORT = 7000
const DEFAULT_SERVER_IP = "127.0.0.1" # IPv4 localhost
const MAX_CONNECTIONS = 2
var SERVER_IP 
var SERVER_PORT
@export var playerScene : PackedScene
var debug = "player"
var thread = null
@export var Level : PackedScene

# This will contain player info for every player,
# with the keys being each player's unique IDs.
@export var players = {}

# This is the local player info. This should be modified locally
# before the connection is made. It will be passed to every other peer.
# For example, the value of "name" can be set to something the player
# entered in a UI scene.
var player_info = {"name": "Name"}

var players_loaded = 0
var min_players = 2
var players_connected = 0



func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)


func join_game(address = "", port = ""):
	if address.is_empty():
		address = DEFAULT_SERVER_IP
	else:
		address = SERVER_IP
	if port.is_empty():
		port = PORT
	else:
		port = SERVER_PORT
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, port)

	if error:
		return error
	
	multiplayer.multiplayer_peer = peer
	var s = multiplayer.get_unique_id()
	GlobalControl.players[s]=player_info

func create_game():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_CONNECTIONS)
	if error:
		return error
	multiplayer.multiplayer_peer = peer
	thread = Thread.new()
	thread.start(start_upnp.bind(PORT))
	
	GlobalControl.players[1] = player_info
	players[1] = player_info
	player_connected.emit(1, player_info)

func start_upnp(port):
	var upnp = UPNP.new()
	upnp.discover()
	upnp.add_port_mapping(port)

func _exit_tree():
	if thread != null:
		thread.wait_to_finish()


func remove_multiplayer_peer():
	multiplayer.multiplayer_peer = null


# When the server decides to start the game from a UI scene,
# do Lobby.load_game.rpc(filepath)
func load_game(game_scene_path):
	hideUI()
	if multiplayer.is_server():
		change_level.call_deferred(load(game_scene_path))
@rpc("call_local")
func hideUI():
	$VBoxContainer.hide()
	$HBoxContainer.hide()
func change_level(scene: PackedScene):
	var level = $Level
	for c in level.get_children():
		level.remove_child(c)
		c.queue_free()
	level.add_child(scene.instantiate())

# Every peer will call this when they have loaded the game scene.
@rpc("any_peer", "call_local", "reliable")
func player_loaded():
	if multiplayer.is_server():
		players_loaded += 1
		if players_loaded == players.size():
			$/root/Game.start_game()
			players_loaded = 0


# When a peer connects, send them my player info.
# This allows transfer of all desired data for each player, not only the unique ID.
func _on_player_connected(id):
	_register_player.rpc_id(id, player_info)
	


@rpc("any_peer", "reliable")
func _register_player(new_player_info):
	var new_player_id = multiplayer.get_remote_sender_id()
	players[new_player_id] = new_player_info
	GlobalControl.players[new_player_id] = new_player_info
	player_connected.emit(new_player_id, new_player_info)


func _on_player_disconnected(id):
	players.erase(id)
	player_disconnected.emit(id)
	players_connected -= 1


func _on_connected_ok():
	var peer_id = multiplayer.get_unique_id()
	players[peer_id] = player_info
	player_connected.emit(peer_id, player_info)
	player_connected_count.rpc()

@rpc("any_peer", "call_remote", )
func player_connected_count():
	players_connected += 1

func _on_connected_fail():
	multiplayer.multiplayer_peer = null


func _on_server_disconnected():
	multiplayer.multiplayer_peer = null
	players.clear()
	server_disconnected.emit()

#connect
func _on_button_pressed():
	if not $HBoxContainer/PanelContainer/VBoxContainer/LineEdit3.text.is_empty():
		player_info["name"] = $HBoxContainer/PanelContainer/VBoxContainer/LineEdit3.text
		SERVER_IP = $HBoxContainer/PanelContainer/VBoxContainer/LineEdit.text
		SERVER_PORT = $HBoxContainer/PanelContainer/VBoxContainer/LineEdit2.text
		$VBoxContainer/Label.text = "Waiting for host"
		join_game(SERVER_IP)
	else:
		print("No username set")

#host
func _on_button_2_pressed():
	if not $HBoxContainer/PanelContainer/VBoxContainer/LineEdit3.text.is_empty():
		player_info["name"] = $HBoxContainer/PanelContainer/VBoxContainer/LineEdit3.text
		GlobalControl.player_info["name"] = $HBoxContainer/PanelContainer/VBoxContainer/LineEdit3.text
		SERVER_PORT = $HBoxContainer/PanelContainer/VBoxContainer/LineEdit2.text
		$VBoxContainer/Label.text = "Waiting for players"
		$"VBoxContainer/Start Game Button".visible = true
		create_game()
		players_connected = 1
		debug = "host"
	else:
		print("No username set")


func _on_start_game_button_pressed():
	if players_connected >= min_players:
		load_game(str(Level.resource_path))
