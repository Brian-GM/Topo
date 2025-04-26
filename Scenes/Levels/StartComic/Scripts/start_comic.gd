extends Control

var animation_player: AnimationPlayer

func _ready() -> void:
	GameManager.hud_visibility(false)
	GameManager.is_cinematic_active = true
	animation_player = get_node("AnimationPlayer")
	animation_player.play("play_comic")
	await animation_player.animation_finished
	GameManager.is_cinematic_active = false
	GameManager.hud_visibility(true)
	GameManager.next_level()
