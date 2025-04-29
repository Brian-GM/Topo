extends Area2D

var player_in_range: bool = false
var sprite: Sprite2D


func _ready() -> void:
	sprite = get_node("Sprite2D")
	match GameManager.current_level:
		1:
			sprite.texture = load("res://Assets/BrianSprites/boquete1.png")
		2:
			sprite.texture = load("res://Assets/BrianSprites/boquete2.png")
		3:
			sprite.texture = load("res://Assets/BrianSprites/boquete3.png")
		5:
			sprite.texture = load("res://Assets/BrianSprites/boquete4.png")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		body.enter_hole_range(self)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		body.exited_hole_range()
