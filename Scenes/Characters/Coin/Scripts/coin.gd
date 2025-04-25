extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameManager.coins += 1
		queue_free()
