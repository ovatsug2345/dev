extends Node3D
var synced = false
var SPAWN_RANDOM := 5.0
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
	
	remoteAudioSetup.rpc()
	remotePositionSync.rpc()
	
	
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
	character.position = Vector3(SPAWN_RANDOM,0,0)
	SPAWN_RANDOM += 5
	var spawnpoint = Vector3(SPAWN_RANDOM,0,0)
	character.name = str(id)
	$"Level manager".add_child(character, true)
	var s = character.get_path()
	var audio = get_node(s).get_node("AudioManager")
	var body = get_node(s).get_node("CharacterBody3D")
	GlobalControl.AudioSetup[id] = audio
	GlobalControl.SpawnPoint[spawnpoint] = body
	
	
@rpc("any_peer","call_local", "reliable")
func remoteAudioSetup():
	for i in GlobalControl.AudioSetup:
		var audionode = GlobalControl.AudioSetup[i]
		audionode.setupAudio(i)
		
@rpc("any_peer","call_local", "reliable")
func remotePositionSync():
	for i in GlobalControl.SpawnPoint:
		print(str(GlobalControl.SpawnPoint[i].position))
		print(str(i))
		GlobalControl.SpawnPoint[i].position = i
		print(str(GlobalControl.SpawnPoint[i].position))

func del_player(id: int):
	if not $"Level manager".has_node(str(id)):
		return
	$"Level manager".get_node(str(id)).queue_free()




func _on_multiplayer_spawner_spawned(_node):
	remoteAudioSetup.rpc()
