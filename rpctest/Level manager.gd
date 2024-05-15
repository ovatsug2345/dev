extends Node
@export var player : PackedScene
@export var OriginNode : Node3D

func _arready():
	var spawnpoint = OriginNode.position
	await get_tree().create_timer(1).timeout
	#audio handling
	for i in GlobalControl.players:
		var s = player.instantiate()
		add_child(s)
		s.name = str(i)
		s.position = spawnpoint
		spawnpoint += Vector3(1,1,1)
		s.get_node("AudioManager").setupAudio(i)
	
	var ownid = multiplayer.get_unique_id()
	for i in $".".get_children():
		if i.name == str(ownid):
			i.get_child(0).ownCamera.make_current()
