extends StaticBody2D

var jugador_en_rango: bool = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		jugador_en_rango = true
		body.entrar_exp_en_rango(self)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		jugador_en_rango = false
		body.salir_exp_en_rango()
