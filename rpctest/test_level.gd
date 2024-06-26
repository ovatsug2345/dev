extends Node3D
var synced = false
var SPAWN_RANDOM := 5.0
@export var characterscene : PackedScene
@export var spawnpoint : Node3D

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
	
	remoteAudioSetup()

func remoteAudioSetup():
	for i in GlobalControl.AudioSetup:
		var audionode = GlobalControl.AudioSetup[i]
		remoteAudioSetup2(audionode,i)
@rpc("any_peer","call_local", "reliable")
func remoteAudioSetup2(audionode,i):
	audionode.setupAudio(i)

func add_player(id: int):
	var character = characterscene.instantiate()
	# Set player id.
	character.get_child(0).player = id
	# Randomize character position.
	character.position = spawnpoint.position + Vector3(SPAWN_RANDOM,0,0)
	SPAWN_RANDOM += 5
	character.name = str(id)
	$"Level manager".add_child(character, true)
	var audio = character.get_node("AudioManager")
	GlobalControl.AudioSetup[id] = audio

func del_player(id: int):
	if not $"Level manager".has_node(str(id)):
		return
	$"Level manager".get_node(str(id)).queue_free()

func _on_multiplayer_spawner_spawned(node):
	var a = node.get_node("AudioManager")
	var b = node.name
	a.setupAudio(b)

func _exit_tree():
	if not multiplayer.is_server():
		return
	multiplayer.peer_connected.disconnect(add_player)
	multiplayer.peer_disconnected.disconnect(del_player)
