extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Topo"):
		%cantidad_oro.set_text(str(int(%cantidad_oro.text) + 1))
		GameManager.coins = int(%cantidad_oro.text)
		print(GameManager.coins)
		queue_free()
