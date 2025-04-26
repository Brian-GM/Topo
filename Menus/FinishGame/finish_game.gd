extends Node2D


var back_to_main_menu: Button
var button_pressed: bool

var animation_player: AnimationPlayer


func _ready() -> void:
	#if AudioManager.audio_stream_players.has("background_dungeon.mp3"):
		#AudioManager.stop("background_dungeon.mp3", 2.0)
	
	animation_player = get_node("AnimationPlayer")
	#animation_player.play("fade_in")
	
	back_to_main_menu = get_node("CanvasLayer/Control/CenterContainer/MenuContainer/BackButton")
	back_to_main_menu.grab_focus()
	
	#if !AudioManager.audio_stream_players.has("main_title.mp3"):
		#AudioManager.play_music("main_title.mp3", 2.0, true, 2.0, 0.4)
	
	button_pressed = false


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
	back_to_main_menu.icon = preload("res://Assets/BrianSprites/UI/fondobotonhoveeer.png")


func _on_back_button_focus_exited() -> void:
	back_to_main_menu.icon = preload("res://Assets/BrianSprites/UI/fondoboton.png")
