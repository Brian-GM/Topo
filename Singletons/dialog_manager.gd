extends Node

var text_box_scene: PackedScene

var full_dialog_lines: String = ""
var dialog_lines: Array[String] = []
var current_line_index: int = 0

var text_box: CanvasLayer
var text_box_position: Vector2

var is_dialog_active: bool = false
var can_advance_line: bool = false

var is_auto_dialog: bool = false
var auto_dialog_duration: Array[float] = [0.0]

signal finished_all_dialog_lines()


func _ready() -> void:
	text_box_scene = load("res://UI/TextBox/text_box.tscn")


func start_dialog(position: Vector2, lines: Array[String], auto_dialog: bool = false, duration: Array[float] = [0.0]) -> void:
	if is_dialog_active:
		return
	
	is_auto_dialog = auto_dialog
	auto_dialog_duration = duration
	
	dialog_lines = lines
	text_box_position = position
	show_text_box()
	
	is_dialog_active = true


func update_text_box_position(position: Vector2) -> void:
	text_box_position = position


func show_text_box() -> void:
	text_box = text_box_scene.instantiate() as CanvasLayer
	text_box.connect("finished_displaying", on_text_box_finished_displaying)
	
	get_tree().root.add_child(text_box)
	
	text_box.get_node("TextBox").global_position = (text_box.get_viewport().canvas_transform * text_box_position)
	text_box.call_deferred("display_text", dialog_lines[current_line_index], is_auto_dialog, float(auto_dialog_duration[current_line_index]))
	
	can_advance_line = false

func show_full_text_box() -> void:
	if text_box:
		can_advance_line = true
		text_box.call_deferred("display_full_text")

func on_text_box_finished_displaying(time_to_wait: float = 0.0) -> void:
	if is_auto_dialog:
		await get_tree().create_timer(time_to_wait).timeout
		
		can_advance_line = true
		
		text_box.queue_free()
		current_line_index += 1
		
		if current_line_index >= dialog_lines.size():
			is_dialog_active = false
			current_line_index = 0
			finished_all_dialog_lines.emit()
			return
		show_text_box()
	else: 
		can_advance_line = true


func _unhandled_input(event: InputEvent) -> void:
	if is_auto_dialog:
		return
	
	if event.is_action_pressed("continue_dialog") and is_dialog_active and can_advance_line:
		AudioManager.play_sound("bong.ogg")
		text_box.queue_free()
		current_line_index += 1
		
		if current_line_index >= dialog_lines.size():
			is_dialog_active = false
			current_line_index = 0
			return
		
		show_text_box()
	elif event.is_action_pressed("continue_dialog") and is_dialog_active:
		show_full_text_box()
