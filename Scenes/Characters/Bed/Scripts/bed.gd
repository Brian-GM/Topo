extends StaticBody2D

var player_in_range: bool = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		body.enter_bed_range(self)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		body.exited_bed_range()
