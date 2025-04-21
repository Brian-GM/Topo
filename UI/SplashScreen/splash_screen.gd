extends CanvasLayer

var animation_player: AnimationPlayer

func _ready() -> void:
	animation_player = get_node("AnimationPlayer")
	AudioManager.play_sound("NootNoot.ogg", 0.0, false, 0.0, 0.5)
	animation_player.play("splash_screen")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://Menus/MainTitle/main_title.tscn")
