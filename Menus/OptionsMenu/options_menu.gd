extends CanvasLayer

var option_button: OptionButton
var percentage: Label
var volume_slider: HSlider
var back_button: Button

var background: Node2D
var gray_background: ColorRect
var background_menu: ColorRect
var center_container: CenterContainer
var margin_container: MarginContainer

var h_box_container: HBoxContainer

var button_pressed: bool

var animation_player: AnimationPlayer


func _enter_tree() -> void:
	animation_player = get_node("AnimationPlayer")
	#if !GameManager.game_first_load:
	#animation_player.autoplay = "RESET_BLACK"
	#animation_player.autoplay = "RESET_POSITION"
	#animation_player.play("RESET_POSITION")
	#if !get_tree().paused:
		#animation_player.autoplay = "RESET_BLACK"
		#animation_player.play("fade_in")
	#else:
		#animation_player.autoplay = "RESET_WHITE"


func _ready() -> void:
	#animation_player = get_node("AnimationPlayer")
	
	#if !get_tree().paused:
		#animation_player.play("fade_in")
	
	center_container = get_node("CanvasLayer/Control/CenterContainer")
	
	background = get_node("CanvasLayer/Control/Background")
	gray_background = get_node("CanvasLayer/Control/GrayBackground")
	background_menu = get_node("CanvasLayer/Control/CenterContainer/BackgroundMenu")
	margin_container = get_node("CanvasLayer/Control/MarginContainer")
	if !get_tree().paused:
		#margin_container.visible = true
		center_container.set_anchors_preset(Control.PRESET_FULL_RECT)
		gray_background.color = Color.hex(0x00000000)
		
		background_menu.modulate = Color(0, 0, 0, 0)
		background_menu.custom_minimum_size.x = get_viewport().get_visible_rect().size.x
		background_menu.custom_minimum_size.y = get_viewport().get_visible_rect().size.y
	else:
		#margin_container.visible = false
		center_container.set_anchors_preset(Control.PRESET_CENTER)
		gray_background.color = Color.hex(0x40404082)
		background.modulate = Color(0, 0, 0, 0)
		background_menu.custom_minimum_size.x = 1000.0
		background_menu.custom_minimum_size.y = 700.0
	
	option_button = get_node("CanvasLayer/Control/CenterContainer/GridContainer/GridContainer/FlowContainer/OptionButton")
	option_button.select(0 if GameManager.game_language == "en" else 1)
	option_button.grab_focus()
	
	
	percentage = get_node("CanvasLayer/Control/CenterContainer/GridContainer/GridContainer/FlowContainer2/GridContainer/Percentage")
	percentage.text = "{0}%".format([str(db_to_linear(AudioServer.get_bus_volume_db(0)) * 100).lpad(3, "0")])
	
	volume_slider = get_node("CanvasLayer/Control/CenterContainer/GridContainer/GridContainer/FlowContainer2/GridContainer/VolumeSlider")
	volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	
	h_box_container = get_node("CanvasLayer/Control/CenterContainer/BackgroundMenu/MarginContainer/CenterContainer/GridContainer2/HBoxContainer3")
	h_box_container.visible = false
	
	button_pressed = false
	
	gray_background.visible = get_tree().paused
	background.visible = not get_tree().paused
	
	var popup_menu: PopupMenu = (option_button.get_popup() as PopupMenu)
	var styles: StyleBoxFlat = StyleBoxFlat.new()
	styles.bg_color = Color("#FFFFFF")
	popup_menu.set("theme_override_styles/panel", styles)
	
	styles = StyleBoxFlat.new()
	styles.bg_color = Color("#db6212")
	popup_menu.set("theme_override_styles/hover", styles)
	
	styles = StyleBoxFlat.new()
	styles.bg_color = Color(255, 255, 255, 1)
	popup_menu.set("theme_override_colors/font_color", styles)
	
	styles = StyleBoxFlat.new()
	styles.bg_color = Color(255, 255, 255, 1)
	popup_menu.set("theme_override_colors/font_hover_color", styles)
	
	back_button = get_node("CanvasLayer/Control/CenterContainer/GridContainer/GridContainer/BackButton")


#func _unhandled_input(event: InputEvent) -> void:
	#if not button_pressed:
		#if event.is_action_pressed("continue_dialog"):
			#AudioManager.play_sound("confirmation.ogg", 0.0, false, 0.0, 0.5)


# change language 
func _on_option_button_item_selected(index: int) -> void:
	if index == 0:
		GameManager.game_language = "en"
		TranslationServer.set_locale("en")
	else:
		GameManager.game_language = "es"
		TranslationServer.set_locale("es")


func _on_volume_slider_focus_entered() -> void:
	h_box_container.visible = true


func _on_volume_slider_focus_exited() -> void:
	h_box_container.visible = false


# change volume
func _on_volume_slider_value_changed(value: float) -> void:
	percentage.text = "{0}%".format([str(int(value * 100)).lpad(3, "0")])
	AudioServer.set_bus_volume_db(0, linear_to_db(value))


# go back
func _on_back_button_pressed() -> void:
	if not button_pressed:
		button_pressed = true
		if GameManager.last_scene != "":
			if GameManager.last_scene.contains("GameOver"):
				#animation_player.play("fade_out_to_menu")
				#await animation_player.animation_finished
				button_pressed = false
				get_tree().change_scene_to_file("res://Menus/GameOver/game_over.tscn")
			else:
				GameManager.pause_game_menu_visibility(true)
				GameManager.last_scene = ""
				button_pressed = false
				queue_free()
		else:
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
	back_button.grab_focus()


func _on_volume_slider_mouse_entered() -> void:
	back_button.release_focus()
	volume_slider.grab_focus()


func _on_option_button_mouse_entered() -> void:
	option_button.grab_focus()
