extends Area2D

@export var lifetime := 0.2

func _ready():
	$CollisionPolygon2D.disabled = false
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		body.Golpe()
