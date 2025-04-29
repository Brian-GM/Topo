extends Node2D

func _ready() -> void:
	GameManager.hud_visibility(true)
	
	if AudioManager.audio_stream_players.has("cancion1topo.wav"):
		AudioManager.stop("cancion1topo.wav", 1.0)
		
	AudioManager.play_music("TemaPrincipal.mp3", 1.0, true, 0.0, 0.2)
