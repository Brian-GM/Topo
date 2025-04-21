extends Area2D

var speed: float = 400.0
var direction: Vector2 = Vector2.ZERO

const MARGIN: float = 50.0


func _process(delta):
	if direction != Vector2.ZERO:
		position += direction.normalized() * speed * delta
	
	rotate(deg_to_rad(5))
	
	var screen_size: Vector2 = get_viewport_rect().size
	
	if position.x < -MARGIN or position.x > screen_size.x + MARGIN or position.y < -MARGIN or position.y > screen_size.y + MARGIN:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.Golpe()
		queue_free()
