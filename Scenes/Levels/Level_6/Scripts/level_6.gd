extends Node2D

func _ready() -> void:
	AudioManager.stop("cancion1topo.wav",0.0)
	AudioManager.play_music("GabMetal_Def.mp3",0.0,true,0.0,0.2)
