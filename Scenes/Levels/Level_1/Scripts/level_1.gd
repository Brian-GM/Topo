extends Node2D

func _ready() -> void:
	AudioManager.stop("menu.wav",0.0)
	AudioManager.play_music("cancion1topo.wav",0.0,true,0.0,0.2)
