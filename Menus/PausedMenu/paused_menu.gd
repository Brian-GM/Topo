extends Control

var resume_game: Button
var options: Button
var back_to_main: Button
var quit_button: Button

var options_menu_scene: PackedScene
var options_menu: CanvasLayer

var button_pressed: bool

var animation_player: AnimationPlayer
var background: Node2D


func _enter_tree() -> void:
	animation_player = get_node("AnimationPlayer")


func _ready() -> void:
	if OS.has_feature("web"):
		(get_node("CanvasLayer/Control/CenterContainer/MenuContainer/ButtonsContainer/QuitButton") as Button).visible = false
	
	background = get_node("Control/Background")
	background.visible = false
	
	options_menu_scene = load("res://Menus/OptionsMenu/options_menu.tscn")
	
	resume_game = get_node("CanvasLayer/Control/CenterContainer/MenuContainer/ButtonsContainer/ResumeGame")
	resume_game.grab_focus()
	
	options = get_node("CanvasLayer/Control/CenterContainer/MenuContainer/ButtonsContainer/OptionsMenu")
	back_to_main = get_node("CanvasLayer/Control/CenterContainer/MenuContainer/ButtonsContainer/BackToMainMenu")
	quit_button = get_node("CanvasLayer/Control/CenterContainer/MenuContainer/ButtonsContainer/QuitButton")
	
	button_pressed = false


func _on_resume_game_pressed() -> void:
	if not button_pressed:
		button_pressed = true
		#AudioManager.play_sound("confirmation.ogg", 0.0, false, 0.0, 0.5)
		#await AudioManager.audio_stream_players["confirmation.ogg"].finished
		button_pressed = false
		GameManager.pause_game(false) # unpuause game


func _on_options_menu_pressed() -> void:
	if not button_pressed:
		button_pressed = true
		#AudioManager.play_sound("confirmation.ogg", 0.0, false, 0.0, 0.5)
		#await AudioManager.audio_stream_players["confirmation.ogg"].finished
		
		
		GameManager.pause_game_menu_visibility(false) # hide paused menu
		
		# show options menu
		options_menu = options_menu_scene.instantiate() as CanvasLayer
		
		button_pressed = false
		get_tree().current_scene.add_child(options_menu)
		move_child(options_menu, 0)


func _on_back_to_main_menu_pressed() -> void:
	if not button_pressed:
		button_pressed = true
		#AudioManager.play_sound("confirmation.ogg", 0.0, false, 0.0, 0.5)
		
		
		#animation_player.play("fade_out_to_menu")
		#await animation_player.animation_finished
		button_pressed = false
		GameManager.pause_game(false) # hide paused menu
		GameManager.reset_game_stats()
		get_tree().change_scene_to_file("res://Menus/MainTitle/main_title.tscn") # go to main title


func _on_quit_button_pressed() -> void:
	if not button_pressed:
		button_pressed = true
		#AudioManager.play_sound("confirmation.ogg", 0.0, false, 0.0, 0.5)
		#await AudioManager.audio_stream_players["confirmation.ogg"].finished
		button_pressed = false
		get_tree().quit() # close game


func _on_resume_game_focus_entered() -> void:
	resume_game.icon = preload("res://Assets/BrianSprites/UI/fondobotonhoveeer.png")


func _on_resume_game_focus_exited() -> void:
	resume_game.icon = preload("res://Assets/BrianSprites/UI/fondoboton.png")


func _on_options_menu_focus_entered() -> void:
	options.icon = preload("res://Assets/BrianSprites/UI/fondobotonhoveeer.png")


func _on_options_menu_focus_exited() -> void:
	options.icon = preload("res://Assets/BrianSprites/UI/fondoboton.png")


func _on_back_to_main_menu_focus_entered() -> void:
	back_to_main.icon = preload("res://Assets/BrianSprites/UI/fondobotonhoveeer.png")


func _on_back_to_main_menu_focus_exited() -> void:
	back_to_main.icon = preload("res://Assets/BrianSprites/UI/fondoboton.png")


func _on_quit_button_focus_entered() -> void:
	quit_button.icon = preload("res://Assets/BrianSprites/UI/fondobotonhoveeer.png")


func _on_quit_button_focus_exited() -> void:
	quit_button.icon = preload("res://Assets/BrianSprites/UI/fondoboton.png")


func _on_resume_game_mouse_entered() -> void:
	resume_game.grab_focus()


func _on_options_menu_mouse_entered() -> void:
	options.grab_focus()


func _on_back_to_main_menu_mouse_entered() -> void:
	back_to_main.grab_focus()


func _on_quit_button_mouse_entered() -> void:
	quit_button.grab_focus()
