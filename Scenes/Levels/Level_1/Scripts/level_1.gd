extends Node2D

func _ready() -> void:
	GameManager.hud_visibility(true)
	
	if AudioManager.audio_stream_players.has("menu.wav"):
		AudioManager.stop("menu.wav", 1.0)
		
	AudioManager.play_music("cancion1topo.wav", 1.0, true, 0.0, 0.2)
