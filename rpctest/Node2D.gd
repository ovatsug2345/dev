extends Node2D

@export var player : PackedScene

func _ready():
	self.position = get_viewport_rect().size/2
	
	#audio handling
	for i in GlobalControl.players:
		var s = player.instantiate()
		add_child(s)
		s.name = str(i)
		s.get_node("AudioManager").setupAudio(i)
	
	
	


# Called only on the server.
func start_game():
	# All peers are ready to receive RPCs in this scene.
	$Label.text = "GAME STARTED"
