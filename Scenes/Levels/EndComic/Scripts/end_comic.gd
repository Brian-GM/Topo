extends Control

var animation_player: AnimationPlayer

func _ready() -> void:
	GameManager.is_cinematic_active = true
	GameManager.hud_visibility(false)
	animation_player = get_node("AnimationPlayer")
	animation_player.play("play_comic")
	await animation_player.animation_finished
	
	GameManager.is_cinematic_active = false
	GameManager.reset_game_stats()
	get_tree().change_scene_to_file("res://Menus/FinishGame/finish_game.tscn")
