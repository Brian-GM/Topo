# Projectile.gd
extends Area2D

@export var speed: float = 400.0
var direction: Vector2 = Vector2.ZERO

func _process(delta):
	if direction != Vector2.ZERO:
		position += direction.normalized() * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.Golpe()
		queue_free()
