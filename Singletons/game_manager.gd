extends Node


const FOCUS_COLOR: String = "#5e3b1b"
const BLUR_COLOR: String = "#000000"

var game_hud: PackedScene
var game_hud_node: CanvasLayer

var is_reset_button_pressed: bool = false


# ====== player ======
signal change_player_life(life: int)

const MAX_PLAYER_LIFE: int = 6
var player_life: int = MAX_PLAYER_LIFE:
	set(new_value):
		if new_value > MAX_PLAYER_LIFE:
			player_life = MAX_PLAYER_LIFE
		else:
			player_life = max(new_value, 0)
		change_player_life.emit(new_value)

var player_attack: float = 1.0

var player_velocity: float = 300.0

var player_defense: float = 1.0

var player_cooldown_shot: float = 1.0

var player_cooldown_claw: float = 0.5

var recovery: float = 1

signal change_coins(coin: int)

var coins: int = 0:
	set(new_value):
		coins = new_value
		change_coins.emit(new_value)

var xp: int = 0
# ====== player ======


var current_level: int = 0

var is_first_time: bool = false

var game_first_load: bool = false
var is_game_started: bool = false:
	set(new_value):
		is_game_started = new_value
		hud_visibility(new_value)


var game_language: String = "en"

var last_scene: String = ""

var paused_menu_scene: PackedScene
var paused_menu_node: Control

var is_cinematic_active: bool = false


func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	#Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	
	# set language
	TranslationServer.set_locale(game_language)
	
	# add the pause menu to use always in the game
	paused_menu_scene = load("res://Menus/PausedMenu/paused_menu.tscn")
	paused_menu_node = paused_menu_scene.instantiate() as Control
	pause_game_menu_visibility(false)
	add_child(paused_menu_node)
	move_child(paused_menu_node, 0)
	
	game_hud = load("res://UI/HUD/hud.tscn")
	game_hud_node = game_hud.instantiate() as CanvasLayer
	hud_visibility(false)
	add_child(game_hud_node)
	move_child(game_hud_node, 1)
	
	reset_game_stats()


func _unhandled_input(event: InputEvent) -> void:
	if is_cinematic_active:
		return
	# when the game start can be paused pressing the key escape
	if event.is_action_pressed("pause_game") and GameManager.is_game_started:
		pause_game(true)


# reset games variables
func reset_game_stats() -> void:
	last_scene = ""
	reset_player_stats()
	current_level = 0
	is_game_started = false
	is_reset_button_pressed = false
	hud_visibility(false)


# reset player variables
func reset_player_stats() -> void:
	player_life = MAX_PLAYER_LIFE
	player_attack = 1.0
	player_velocity = 300.0
	player_defense = 1.0
	player_cooldown_shot = 1.0
	player_cooldown_claw = 0.5
	coins = 0
	xp = 0


# function to pause the game
func pause_game(mode: bool) -> void:
	print(mode)
	GameManager.is_game_started = not mode
	pause_game_menu_visibility(mode)
	# get focus on the button
	#(paused_menu_node.get_node("CanvasLayer/Control/CenterContainer/MenuContainer/ButtonsContainer/ResumeGame") as Button).grab_focus()
	get_tree().paused = mode


# show or hide paused menu
func pause_game_menu_visibility(mode: bool) -> void:
	last_scene = get_tree().current_scene.scene_file_path
	paused_menu_node.visible = mode
	(paused_menu_node.get_node("CanvasLayer") as CanvasLayer).visible = mode
	
	# get focus on the button
	if mode:
		(paused_menu_node.get_node("CanvasLayer/Control/CenterContainer/MenuContainer/ButtonsContainer/ResumeGame") as Button).grab_focus()


# change hud visivility
func hud_visibility(mode: bool) -> void:
	game_hud_node.visible = mode


# reset level
func reset_actual_level() -> void:
	is_reset_button_pressed = true
	#reset_player_stats()
	hud_visibility(true)
	if get_tree().change_scene_to_file("res://Scenes/Levels/Level_" + str(current_level) + "/level_" + str(current_level) + ".tscn") != OK:
		get_tree().change_scene_to_file("res://Menus/MainTitle/main_title.tscn")
	#else:
		#if AudioManager.audio_stream_players.has("main_title_background.mp3"):
			#AudioManager.stop("main_title_background.mp3", 4.0)


# go to next level or finnish the game
func next_level() -> void:
	current_level += 1
	if get_tree().change_scene_to_file("res://Scenes/Levels/Level_" + str(current_level) + "/level_" + str(current_level) + ".tscn") != OK:
		reset_game_stats()
		get_tree().change_scene_to_file("res://Menus/FinishGame/finish_game.tscn")
	#else:dd
		#reset_player_stats()


func finish_game() -> void:
	reset_game_stats()
	#GameManager.is_cinematic_active = true
	#if get_tree().current_scene.get_node_or_null("AnimationPlayer") != null:
		#if (get_tree().current_scene.get_node("AnimationPlayer") as AnimationPlayer).has_animation("fade_out"):
			#(get_tree().current_scene.get_node("AnimationPlayer") as AnimationPlayer).play("fade_out")
			#await (get_tree().current_scene.get_node("AnimationPlayer") as AnimationPlayer).animation_finished
	#GameManager.is_cinematic_active = false
	hud_visibility(false)
	get_tree().change_scene_to_file("res://Scenes/Levels/EndComic/end_comic.tscn")

# game over
func game_over() -> void:
	reset_player_stats()
	#GameManager.is_cinematic_active = true
	#if get_tree().current_scene.get_node_or_null("AnimationPlayer") != null:
		#if (get_tree().current_scene.get_node("AnimationPlayer") as AnimationPlayer).has_animation("fade_out"):
			#(get_tree().current_scene.get_node("AnimationPlayer") as AnimationPlayer).play("fade_out")
			#await (get_tree().current_scene.get_node("AnimationPlayer") as AnimationPlayer).animation_finished
	#GameManager.is_cinematic_active = false
	hud_visibility(false)
	get_tree().change_scene_to_file("res://Menus/GameOver/game_over.tscn")


func exit_game() -> void:
	get_tree().quit()
