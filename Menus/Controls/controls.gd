extends Node2D

var back_button: Button

var button_pressed: bool

var animation_player: AnimationPlayer

func _enter_tree() -> void:
	animation_player = get_node("AnimationPlayer")
	#if !GameManager.game_first_load:
	#animation_player.autoplay = "RESET_BLACK"
	#animation_player.play("RESET_BLACK")
	#else:
		#animation_player.autoplay = "RESET_WHITE"
		#animation_player.play("RESET_WHITE")


func _ready() -> void:
	#animation_player.play("fade_in")
	AudioManager.play_sound("GabMetal_Def.mp3",0.0,false,0.0,0.3)
	back_button = get_node("CanvasLayer/Control/CenterContainer/MenuContainer/BackButton")
	back_button.grab_focus()
	
	button_pressed = false
	
	#if AudioManager.audio_stream_players.has("background_dungeon.mp3"):
		#AudioManager.stop("background_dungeon.mp3", 2.0)


func _on_back_button_pressed() -> void:
	if not button_pressed:
		button_pressed = true
		#AudioManager.play_sound("confirmation.ogg", 0.0, false, 0.0, 0.5)
		#animation_player.play("fade_out")
		#await animation_player.animation_finished
		button_pressed = false
		AudioManager.play_sound("hover_click.mp3",0.0,false,0.0,0.3)
		get_tree().change_scene_to_file("res://Menus/MainTitle/main_title.tscn")


func _on_back_button_focus_entered() -> void:
	back_button.icon = preload("res://Assets/BrianSprites/UI/fondobotonhoveeer.png")


func _on_back_button_focus_exited() -> void:
	back_button.icon = preload("res://Assets/BrianSprites/UI/fondoboton.png")


func _on_back_button_mouse_entered() -> void:
	back_button.icon = preload("res://Assets/BrianSprites/UI/fondobotonhoveeer.png")
