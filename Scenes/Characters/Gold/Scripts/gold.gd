extends Area2D

var ororecogido = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Topo"):
		queue_free()
		ororecogido += 1
		%cantidad_oro.set_text(str(ororecogido))
		print("Oro Recogido - "+str(ororecogido))
