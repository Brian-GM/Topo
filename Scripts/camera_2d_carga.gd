extends Camera2D

@export var target: Node2D  # Asigna tu nodo "Topo" aquí en el inspector

func _process(delta):
	if target:
		# Solo actualizamos la posición Y, manteniendo la X original
		position.y = target.position.y
