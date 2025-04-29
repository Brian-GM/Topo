extends Node

var audio_enabled := true

const MUSIC_PATH := "res://Assets/Music/"
const SOUND_PATH := "res://Assets/Sound/"

#@onready var music_player := AudioStreamPlayer.new()
#@onready var sound_player := AudioStreamPlayer.new()

var audio_stream_players: Dictionary = {}

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	#music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	#sound_player.process_mode = Node.PROCESS_MODE_ALWAYS
	
	#add_child(music_player)
	#add_child(sound_player)


# modify by Sergio Munoz Sanchez
func play_audio(audio: String, player: AudioStreamPlayer, player_key: String, path: String, fade_in:float = 2.0, auto_loop: bool = false, fade_auto_loop: float = 0.0, set_volume_player: float = 1.0, random_pitch: bool = false, random_pitch_range: Array[float] = [-0.01, 0.01]) -> void:
	if not player:
		return
	
	var stream := load(path + audio) as AudioStream
	
	if not stream:
		return
	
	if random_pitch:
		player.pitch_scale += randf_range(random_pitch_range[0], random_pitch_range[1])
	
	player.stream = stream
	player.volume_db = linear_to_db(0.0)
	player.play()
	await player.create_tween().tween_property(player, "volume_db", linear_to_db(set_volume_player), fade_in).from(linear_to_db(0.1)).finished
	await player.finished
	if auto_loop:
		play_audio(audio, player, player_key, path, fade_auto_loop, true, fade_auto_loop, set_volume_player)
	else:
		stop(player_key, 0.0, player)


# modify by Sergio Munoz Sanchez
func play_music(audio: String, fade_in: float = 2.0, auto_loop: bool = false, fade_auto_loop: float = 0.0, set_volume_music: float = 1.0, random_pitch: bool = false, radom_pitch_range: Array[float] = [-0.01, 0.01]) -> void:
	if audio_enabled:
		var music_player = AudioStreamPlayer.new()
		music_player.process_mode = Node.PROCESS_MODE_ALWAYS
		
		#var music_player_key = add_value_dictionary(audio_stream_players, audio, music_player)		
		if audio_stream_players.has(audio):
			stop(audio, 0.0)
		
		audio_stream_players[audio] = music_player
		
		add_child(music_player)
		play_audio(audio, music_player, audio, MUSIC_PATH, fade_in, auto_loop, fade_auto_loop, set_volume_music, random_pitch, radom_pitch_range)


# modify by Sergio Munoz Sanchez
func play_sound(audio: String, fade_in: float = 0.0, auto_loop: bool = false, fade_auto_loop: float = 0.0, set_volume_sound: float = 1.0, random_pitch: bool = false, radom_pitch_range: Array[float] = [-0.01, 0.01]) -> void:
	if audio_enabled:
		var sound_player = AudioStreamPlayer.new()
		sound_player.process_mode = Node.PROCESS_MODE_ALWAYS
		
		audio_stream_players[audio] = sound_player
		add_child(sound_player)
		play_audio(audio, sound_player, audio, SOUND_PATH, fade_in, auto_loop, fade_auto_loop, set_volume_sound, random_pitch, radom_pitch_range)


func toggle_audio() -> void:
	audio_enabled = not audio_enabled
	AudioServer.set_bus_volume_db(0, linear_to_db(audio_enabled))


# added by Sergio Munoz Sanchez
func set_volume(player_to_change: String, linear_volume: float = 1.0, wait_time: float = 0.0) -> void:
	await get_tree().create_timer(wait_time).timeout
	#var player: AudioStreamPlayer = music_player if player_to_change == "music" else sound_player as AudioStreamPlayer
	if audio_stream_players.has(player_to_change):
		var player: AudioStreamPlayer = audio_stream_players[player_to_change] as AudioStreamPlayer
		player.volume_db = linear_to_db(linear_volume)


# added by Sergio Munoz Sanchez
func stop(player_to_stop: String, fade_out: float = 2.0, player_not_in_dictionary: AudioStreamPlayer = null) -> void:
	#var player: AudioStreamPlayer = music_player if player_to_stop == "music" else sound_player as AudioStreamPlayer
	if player_not_in_dictionary:
		await player_not_in_dictionary.create_tween().tween_property(player_not_in_dictionary, "volume_db", linear_to_db(0.01), 0.0).from(linear_to_db(1.0)).finished
		player_not_in_dictionary.volume_db = linear_to_db(0.0)
		player_not_in_dictionary.stop()
		remove_child(player_not_in_dictionary)
		audio_stream_players.erase(player_to_stop)
	elif audio_stream_players.has(player_to_stop):
		var player: AudioStreamPlayer = audio_stream_players[player_to_stop] as AudioStreamPlayer
		await player.create_tween().tween_property(player, "volume_db", linear_to_db(0.01), fade_out).from(player.volume_db).finished
		player.volume_db = linear_to_db(0.0)
		player.stop()
		remove_child(player)
		audio_stream_players.erase(player_to_stop)
	else:
		if get_children().size() > 0:
			for child in get_children():
				if child is AudioStreamPlayer and (child as AudioStreamPlayer).name == player_to_stop:
					var player: AudioStreamPlayer = (child as AudioStreamPlayer)
					await player.create_tween().tween_property(player, "volume_db", linear_to_db(0.01), fade_out).from(player.volume_db).finished
					player.volume_db = linear_to_db(0.0)
					player.stop()
					remove_child(player)
					audio_stream_players.erase(player_to_stop)
