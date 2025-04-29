extends Control

var animation_player: AnimationPlayer

func _ready() -> void:
	if AudioManager.audio_stream_players.has("menu.wav"):
		AudioManager.stop("menu.wav", 0.0)
	
	if AudioManager.audio_stream_players.has("GabMetal_Def.mp3"):
		AudioManager.stop("GabMetal_Def.mp3", 0.0)
	
	if AudioManager.audio_stream_players.has("TemaPrincipal.mp3"):
		AudioManager.stop("TemaPrincipal.mp3", 0.0)
	
	AudioManager.play_music("end_comic.mp3", 0.0, true, 0.0, 0.3)
	
	GameManager.is_cinematic_active = true
	GameManager.hud_visibility(false)
	
	animation_player = get_node("AnimationPlayer")
	animation_player.play("play_comic")
	await animation_player.animation_finished
	
	GameManager.is_cinematic_active = false
	GameManager.reset_game_stats()
	get_tree().change_scene_to_file("res://Menus/FinishGame/finish_game.tscn")
