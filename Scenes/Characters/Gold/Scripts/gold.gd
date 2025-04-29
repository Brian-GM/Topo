extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Topo"):
		%cantidad_oro.set_text(str(int(%cantidad_oro.text) + 1))
		GameManager.coins += 1
		AudioManager.play_sound("gold.mp3",0.0,false,0.0,0.3)
		queue_free()
