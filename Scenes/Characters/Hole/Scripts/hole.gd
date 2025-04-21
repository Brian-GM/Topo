extends Area2D

var player_in_range: bool = false
var sprite: Sprite2D


func _ready() -> void:
	sprite = get_node("Sprite2D")
	sprite.texture = load("res://Assets/BrianSprites/boquete" + str(GameManager.current_level + 1) + ".png")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		body.enter_hole_range(self)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		body.exited_hole_range()
