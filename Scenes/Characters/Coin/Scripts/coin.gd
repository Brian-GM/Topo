extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		AudioManager.play_sound("Gold (Sound Effect)  Diablo II.mp3.mp3",0.0,false,0.0,0.3)
		GameManager.coins += 1
		queue_free()
