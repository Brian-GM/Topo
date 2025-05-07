extends Node2D

var animation_player : AnimationPlayer

var button_pressed: bool

var reset_level: Button
var back_to_main: Button
var quit: Button


func _ready() -> void:
	if OS.has_feature("web"):
		(get_node("Control/CenterContainer/MenuContainer/ButtonsContainer/QuitButton") as Button).visible = false
	
	AudioManager.stop("TemaPrincipal.mp3", 0.0)
	AudioManager.stop("GabMetal_Def.mp3", 0.0)
	AudioManager.stop("Fight_def.mp3", 0.0)
	
	if not AudioManager.audio_stream_players.has("menu.wav"):
		AudioManager.play_music("menu.wav", 0.0, true, 0.0, 0.3)
	
	#if AudioManager.audio_stream_players.has("background_dungeon.mp3"):
		#AudioManager.stop("background_dungeon.mp3", 2.0)
	
	animation_player = get_node("AnimationPlayer")
	
	reset_level = get_node("Control/CenterContainer/MenuContainer/ButtonsContainer/ResetLevel")
	reset_level.grab_focus()
	
	button_pressed = false
	
	back_to_main = get_node("Control/CenterContainer/MenuContainer/ButtonsContainer/BackToMainMenu")
	quit = get_node("Control/CenterContainer/MenuContainer/ButtonsContainer/QuitButton")
	
	GameManager.is_cinematic_active = true
	animation_player.play("fade_in")
	await animation_player.animation_finished
	GameManager.is_cinematic_active = false
	
	#if not AudioManager.audio_stream_players.has("main_title.mp3"):
		#AudioManager.play_music("main_title.mp3", 1.0, true, 1.0, 0.6)


#func _unhandled_input(event: InputEvent) -> void:
	#if not button_pressed:
		#if event.is_action("move_up") or event.is_action("move_down"):
			#AudioManager.play_sound("bong.ogg")


func _on_reset_level_pressed() -> void:
	if not button_pressed:
		button_pressed = true
		
		#AudioManager.play_sound("confirmation.ogg")
		
		#AudioManager.stop("main_title.mp3", 1.0)
		#animation_player.play("fade_out_reset_level")
		#await animation_player.animation_finished
		
		
		AudioManager.play_sound("hover_click.mp3",0.0,false,0.0,0.3)
		AudioManager.stop("menu.wav", 1.0)
		button_pressed = false
		GameManager.reset_actual_level()


func _on_back_to_main_menu_pressed() -> void:
	if not button_pressed:
		button_pressed = true
		#AudioManager.play_sound("confirmation.ogg")
		GameManager.reset_game_stats()
		
		#animation_player.play("fade_out")
		#await animation_player.animation_finished
		
		button_pressed = false
		AudioManager.play_sound("hover_click.mp3",0.0,false,0.0,0.3)
		get_tree().change_scene_to_file("res://Menus/MainTitle/main_title.tscn")


func _on_quit_button_pressed() -> void:
	if not button_pressed:
		button_pressed = true
		button_pressed = false
		GameManager.exit_game()


func _on_reset_level_focus_entered() -> void:
	reset_level.icon = preload("res://Assets/BrianSprites/UI/fondobotonhoveeer.png")


func _on_reset_level_focus_exited() -> void:
	reset_level.icon = preload("res://Assets/BrianSprites/UI/fondoboton.png")


func _on_back_to_main_menu_focus_entered() -> void:
	back_to_main.icon = preload("res://Assets/BrianSprites/UI/fondobotonhoveeer.png")


func _on_back_to_main_menu_focus_exited() -> void:
	back_to_main.icon = preload("res://Assets/BrianSprites/UI/fondoboton.png")


func _on_quit_button_focus_entered() -> void:
	quit.icon = preload("res://Assets/BrianSprites/UI/fondobotonhoveeer.png")


func _on_quit_button_focus_exited() -> void:
	quit.icon = preload("res://Assets/BrianSprites/UI/fondoboton.png")


func _on_reset_level_mouse_entered() -> void:
	reset_level.grab_focus()


func _on_back_to_main_menu_mouse_entered() -> void:
	back_to_main.grab_focus()


func _on_quit_button_mouse_entered() -> void:
	quit.grab_focus()
