extends Node2D

var golds_1: Node2D
var golds_2: Node2D


func _ready() -> void:
	if not AudioManager.audio_stream_players.has("cancion1topo.wav"):
		AudioManager.play_music("cancion1topo.wav", 1.0, true, 0.0, 0.2)
		
	GameManager.hud_visibility(false)
	golds_1 = get_node("Golds")
	golds_2 = get_node("Golds2")
	
	if (GameManager.current_level % 2 == 0):
		remove_child(golds_2)
	else:
		remove_child(golds_1)


func _on_finish_falling_body_entered(body: Node2D) -> void:
	if body.is_in_group("Topo"):
		GameManager.hud_visibility(true)
		GameManager.reset_store()
		GameManager.next_level()
