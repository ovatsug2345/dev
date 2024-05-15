extends Node3D

const SPAWN_RANDOM := 5.0
@export var characterscene : PackedScene
func _ready():
	# We only need to spawn players on the server.
	if not multiplayer.is_server():
		return

	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(del_player)

	# Spawn already connected players.
	for id in multiplayer.get_peers():
		add_player(id)

	# Spawn the local player unless this is a dedicated server export.
	if not OS.has_feature("dedicated_server"):
		add_player(1)


func _exit_tree():
	if not multiplayer.is_server():
		return
	multiplayer.peer_connected.disconnect(add_player)
	multiplayer.peer_disconnected.disconnect(del_player)


func add_player(id: int):
	var character = characterscene.instantiate()
	# Set player id.
	character.get_child(0).player = id
	# Randomize character position.
	var pos := Vector2.from_angle(randf() * 2 * PI)
	character.position = Vector3(pos.x * SPAWN_RANDOM * randf(), 0, pos.y * SPAWN_RANDOM * randf())
	character.name = str(id)
	$"Level manager".add_child(character, true)
	GlobalControl.AudioSetup[id] = $"Level manager".get_node(str(id)).get_node("AudioManager")
	
@rpc("any_peer","call_local", "reliable")
func remoteAudioSetup():
	for i in GlobalControl.AudioSetup:
		var audionode = GlobalControl.AudioSetup[i]
		audionode.setupAudio(i)

func del_player(id: int):
	if not $"Level manager".has_node(str(id)):
		return
	$"Level manager".get_node(str(id)).queue_free()




func _on_multiplayer_spawner_spawned(node):
	remoteAudioSetup.rpc()
