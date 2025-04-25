extends Area2D


var lifetime: float = 0.2
var animated_sprite: AnimatedSprite2D
var collision_polygon: CollisionPolygon2D


func _ready():
	animated_sprite = get_node("AnimatedSprite2D")
	animated_sprite.play("default")
	
	collision_polygon = get_node("CollisionPolygon2D")
	collision_polygon.disabled = false
	
	await get_tree().create_timer(lifetime).timeout
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("enemy"):
		body.call_deferred("get_damaged")
