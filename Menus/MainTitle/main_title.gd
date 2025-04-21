extends Control

var animation_player: AnimationPlayer

var start_game_button: Button
var options_button: Button
var controls_button: Button
var quit_button: Button

var game_ready_finished: bool = false
var button_pressed: bool = false


func _enter_tree() -> void:
	animation_player = get_node("AnimationPlayer")
	#if !GameManager.game_first_load:
		#animation_player.autoplay = "RESET_BLACK"
		#animation_player.play("RESET_BLACK")
	#else:
		#animation_player.autoplay = "RESET_WHITE"
		#animation_player.play("RESET_WHITE")


func _ready() -> void:
	game_ready_finished = false
	
	#if AudioManager.audio_stream_players.has("background_dungeon.mp3"):
		#AudioManager.stop("background_dungeon.mp3", 2.0)
	
	if OS.has_feature("web"):
		(get_node("GridContainer/Menu/QuitButton") as Button).visible = false
	
	GameManager.reset_game_stats()
	
	start_game_button = get_node("GridContainer/Menu/StartGameButton")
	start_game_button.grab_focus()
	
	options_button = get_node("GridContainer/Menu/OptionsButton")
	controls_button = get_node("GridContainer/Menu/ControlsButton")
	quit_button = get_node("GridContainer/Menu/QuitButton")
	
	button_pressed = false
	
	
	if !GameManager.game_first_load:
		GameManager.game_first_load = true
		
		#if !AudioManager.audio_stream_players.has("main_title.mp3"):
			#AudioManager.play_music("main_title.mp3", 1.0, true, 1.0, 0.6)
		#await get_tree().create_timer(0.5).timeout
		game_ready_finished = true
	else:
		game_ready_finished = true
		#if !AudioManager.audio_stream_players.has("main_title.mp3"):
			#AudioManager.play_music("main_title.mp3", 1.0, true, 1.0, 0.6)


# start the game
func _on_start_game_button_pressed() -> void:
	if not button_pressed and game_ready_finished:
		button_pressed = true
		GameManager.is_cinematic_active = true
		
		#AudioManager.play_sound("confirmation.ogg", 0.0, false, 0.0, 0.5)
		
		#if AudioManager.audio_stream_players.has("main_title.mp3"):
			#AudioManager.stop("main_title.mp3")
		
		#AudioManager.play_music("background_dungeon.mp3", 1.0, true, 0.0, 1.0)
		
		GameManager.is_cinematic_active = false
		GameManager.is_game_started = true
		button_pressed = false
		GameManager.current_level = 1
		GameManager.go_home()


func _on_options_button_pressed() -> void:
	if not button_pressed and game_ready_finished:
		button_pressed = true
		#AudioManager.play_sound("confirmation.ogg", 0.0, false, 0.0, 0.5)
		
		button_pressed = false
		get_tree().change_scene_to_file("res://Menus/OptionsMenu/options_menu.tscn")


func _on_controls_button_pressed() -> void:
	if not button_pressed and game_ready_finished:
		button_pressed = true
		#AudioManager.play_sound("confirmation.ogg", 0.0, false, 0.0, 0.5)
		
		button_pressed = false
		get_tree().change_scene_to_file("res://Menus/Controls/controls.tscn")


func _on_quit_button_pressed() -> void:
	if not button_pressed and game_ready_finished:
		button_pressed = true
		#AudioManager.play_sound("confirmation.ogg", 0.0, false, 0.0, 0.5)
		
		button_pressed = false
		get_tree().quit()


func _on_start_game_button_focus_entered() -> void:
	start_game_button.icon = preload("res://Assets/BrianSprites/UI/fondobotonhoveeer.png")


func _on_start_game_button_focus_exited() -> void:
	start_game_button.icon = preload("res://Assets/BrianSprites/UI/fondoboton.png")


func _on_options_button_focus_entered() -> void:
	options_button.icon = preload("res://Assets/BrianSprites/UI/fondobotonhoveeer.png")


func _on_options_button_focus_exited() -> void:
	options_button.icon = preload("res://Assets/BrianSprites/UI/fondoboton.png")


func _on_controls_button_focus_entered() -> void:
	controls_button.icon = preload("res://Assets/BrianSprites/UI/fondobotonhoveeer.png")


func _on_controls_button_focus_exited() -> void:
	controls_button.icon = preload("res://Assets/BrianSprites/UI/fondoboton.png")


func _on_quit_button_focus_entered() -> void:
	quit_button.icon = preload("res://Assets/BrianSprites/UI/fondobotonhoveeer.png")


func _on_quit_button_focus_exited() -> void:
	quit_button.icon = preload("res://Assets/BrianSprites/UI/fondoboton.png")


func _on_start_game_button_mouse_entered() -> void:
	start_game_button.grab_focus()


func _on_options_button_mouse_entered() -> void:
	options_button.grab_focus()


func _on_controls_button_mouse_entered() -> void:
	controls_button.grab_focus()


func _on_quit_button_mouse_entered() -> void:
	quit_button.grab_focus()
