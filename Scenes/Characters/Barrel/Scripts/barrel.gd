extends CharacterBody2D


var animated_sprite: AnimatedSprite2D
var collision_shape: CollisionShape2D
var detect_explosion: Area2D

var is_exploting: bool = false

var movement_speed: float = 150.0

var can_moving: bool = true
var is_moving: bool = false
var is_chasing: bool = false
var current_point_index: int = 0

var navigation_agent: NavigationAgent2D

var player: Node2D = null


func _ready():
	animated_sprite = get_node("AnimatedSprite2D")
	navigation_agent = get_node("NavigationAgent2D")
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	
	collision_shape = get_node("DetectPlayer/CollisionShape2D")
	collision_shape.shape.set("radius", (get_viewport_rect().size.x / 2))
	
	detect_explosion = get_node("DetectExplosion")
	
	is_chasing = false
	is_exploting = false
	
	animated_sprite.play("walk")


func _process(_delta):
	if is_chasing and player:
		navigation_agent.target_position = player.global_position


func _physics_process(_delta):
	if GameManager.is_cinematic_active or !can_moving:
		return
	
	is_moving = velocity.length() != 0
	
	if is_moving:
		animated_sprite.flip_h = velocity.x < 0
	
	if navigation_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return
	
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()


func get_damaged() -> void:
	is_exploting = true
	animated_sprite.play("explote")


func _on_detect_player_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		is_chasing = true


func _on_detect_explosion_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if !is_exploting:
			is_exploting = true
			animated_sprite.play("explote")


func _on_animated_sprite_finished() -> void:
	print(animated_sprite.animation)
	if animated_sprite.animation == "explote":
		animated_sprite.play("death")
	
	if animated_sprite.animation == "death" and is_exploting:
		is_exploting = false
		can_moving = false
		var bodies = detect_explosion.get_overlapping_bodies()
		if bodies and bodies.size() > 0:
			for body in bodies:
				if body.is_in_group("player"):
					player.call_deferred("damage")
	elif animated_sprite.animation == "death":
		queue_free()
