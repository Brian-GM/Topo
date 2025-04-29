extends Control

var animation_player: AnimationPlayer

func _ready() -> void:
	if AudioManager.audio_stream_players.has("menu.wav"):
		AudioManager.stop("menu.wav", 0.0)
	
	AudioManager.play_music("start_comic.mp3", 0.0, true, 0.0, 0.3)
	GameManager.hud_visibility(false)
	GameManager.is_cinematic_active = true
	
	animation_player = get_node("AnimationPlayer")
	animation_player.play("play_comic")
	await animation_player.animation_finished
	
	if AudioManager.audio_stream_players.has("start_comic.mp3"):
		AudioManager.stop("start_comic.mp3", 0.0)
	
	GameManager.is_cinematic_active = false
	GameManager.hud_visibility(true)
	GameManager.next_level()
