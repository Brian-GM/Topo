extends Node2D

var golds_1: Node2D
var golds_2: Node2D


func _ready() -> void:
	golds_1 = get_node("Golds")
	golds_2 = get_node("Golds2")
	
	if (GameManager.current_level % 2 == 0):
		remove_child(golds_2)
	else:
		remove_child(golds_1)


func _on_finish_falling_body_entered(body: Node2D) -> void:
	GameManager.next_level()
