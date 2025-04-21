extends CanvasLayer

var text_box: MarginContainer
var label: Label
var letter_display_timer: Timer

const MAX_WIDTH: int = 500

var text: String = ""
var letter_index: int = 0

var letter_time: float = 0.03
var space_time: float = 0.06
var punctuation_time: float = 0.2

var next_indicator: AnimatedSprite2D

const path_audio: AudioStreamOggVorbis = preload("res://Assets/Sound/talk.ogg")
var audio_player: AudioStreamPlayer

signal finished_displaying(time_to_wait: float)

var is_auto_dialog_tex_box: bool = false
var auto_dialog_duration_tex_box: float = 0.0


func _ready() -> void:
	text_box = get_node("TextBox")
	
	text_box.scale = Vector2.ZERO
	
	label = get_node("TextBox/MarginContainer/Label")
	letter_display_timer = get_node("TextBox/LetterDisplayTimer")
	
	next_indicator = get_node("TextBox/NinePatchRect/Control/NextIndicator")
	next_indicator.play("default")
	
	audio_player = AudioStreamPlayer.new()
	audio_player.stream = path_audio
	audio_player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(audio_player)


func display_text(text_to_display: String, is_auto_dialog: bool = false, auto_dialog_duration: float = 0.0) -> void:
	text = TranslationServer.translate(text_to_display)
	label.text = text_to_display
	
	await text_box.resized
	
	text_box.custom_minimum_size.x = min(text_box.size.x, MAX_WIDTH)
	
	if text_box.size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await text_box.resized
		await text_box.resized
		text_box.custom_minimum_size.y = text_box.size.y
	
	text_box.global_position.x -= text_box.size.x / 2
	text_box.global_position.y -= text_box.size.y + 45
	
	label.text = ""
	
	text_box.pivot_offset = Vector2(text_box.size.x / 2, text_box.size.y)
	
	get_tree().create_tween().tween_property(text_box, "scale", Vector2(1, 1), 0.15).set_trans(Tween.TRANS_BACK)
	
	is_auto_dialog_tex_box = is_auto_dialog
	auto_dialog_duration_tex_box = auto_dialog_duration
	
	display_letter()


func display_full_text() -> void:
	letter_index = (text.length() - 1)
	finished_displaying.emit(0.0)
	label.text = text
	play_talk_sound()


func display_letter() -> void:
	label.text += text[letter_index]
	
	letter_index += 1
	if letter_index >= text.length():
		finished_displaying.emit(auto_dialog_duration_tex_box)
		if not is_auto_dialog_tex_box:
			next_indicator.visible = true
		is_auto_dialog_tex_box = false
		auto_dialog_duration_tex_box = 0.0
		return
	
	match text[letter_index]:
		"!", ".", ",", "?":
			letter_display_timer.start(punctuation_time)
		" ":
			letter_display_timer.start(space_time)
		_:
			letter_display_timer.start(letter_time)
			
			if text[letter_index] in ["a", "e", "i", "o", "u"]:
				play_talk_sound()


func play_talk_sound() -> void:
	var new_audio_player: AudioStreamPlayer = audio_player.duplicate() as AudioStreamPlayer
	new_audio_player.pitch_scale += randf_range(-0.11, -0.01)
	get_tree().root.add_child(new_audio_player)
	new_audio_player.play()
	await  new_audio_player.finished
	new_audio_player.queue_free()


func _on_letter_display_timer_timeout() -> void:
	display_letter()
