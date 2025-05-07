extends Node2D


var camera: Camera2D


func _ready() -> void:
	camera = get_node("Mole/Camera2D")
	GameManager.hud_visibility(true)
	
	if AudioManager.audio_stream_players.has("cancion1topo.wav"):
		AudioManager.stop("cancion1topo.wav", 1.0)
		
	AudioManager.play_music("Fight_def.mp3", 1.0, true, 0.0, 1)
	
	camera.zoom = Vector2(0.7, 0.7)
