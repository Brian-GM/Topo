extends Area2D

var speed: float = 650.0
var direction: Vector2 = Vector2.ZERO

var camera: Camera2D

const MARGIN: float = 50.0


func _process(delta):
	if direction != Vector2.ZERO:
		position += direction.normalized() * speed * delta
	
	rotate(deg_to_rad(10 * (-1 if direction.normalized().x <= 0 else 1)))
	
	var screen_size: Vector2 = get_viewport_rect().size
	var camera := get_viewport().get_camera_2d()
	
	if camera:
		var visible_rect := Rect2(camera.global_position - screen_size * 0.5, screen_size)
		var margin_rect := visible_rect.grow(MARGIN)

		if not margin_rect.has_point(global_position):
			queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.call_deferred("get_damaged")
		queue_free()
