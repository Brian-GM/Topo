extends CharacterBody2D


var animated_sprite: AnimatedSprite2D
var collision_shape: CollisionShape2D
var detect_attack: Area2D

var is_attacking: bool = false

var movement_speed: float = 150.0

var can_moving: bool = true
var can_shoot: bool = true
var is_moving: bool = false
var is_chasing: bool = false
var current_point_index: int = 0

var navigation_agent: NavigationAgent2D

var player: Node2D = null

var health: int = 2

var cooldown_shot: float = 2

var miner_projectile_scene: PackedScene = preload("res://Scenes/Enemies/MinerProjectile/miner_projectile.tscn")

var coins: PackedScene = preload("res://Scenes/Characters/Coin/coin.tscn")

func _ready():
	animated_sprite = get_node("AnimatedSprite2D")
	navigation_agent = get_node("NavigationAgent2D")
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	
	collision_shape = get_node("DetectPlayer/CollisionShape2D")
	collision_shape.shape.set("radius", (get_viewport_rect().size.x / 2))
	
	detect_attack = get_node("DetectAttack")
	
	is_chasing = false
	is_attacking = false
	can_shoot = true
	
	animated_sprite.play("walk")


func _process(_delta):
	if is_chasing and player:
		navigation_agent.target_position = player.global_position


func _physics_process(_delta):
	if GameManager.is_cinematic_active or !can_moving:
		return
	
	is_moving = velocity.length() != 0
	
	if is_moving:
		animated_sprite.flip_h = velocity.x > 0
	
	if navigation_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return
	
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()


func get_damaged() -> void:
	health -= 1
	if (health <= 0):
		animated_sprite.play("death")


func _on_detect_player_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		is_chasing = true


func _on_detect_attack_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if !is_attacking:
			is_attacking = true
			can_moving = false
			if can_shoot:
				shoot_projectile(player.global_position - global_position)
				can_shoot = false


func _on_detect_attack_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_attacking = false
		can_moving = true
		animated_sprite.play("walk")


func shoot_projectile(direction: Vector2):
	animated_sprite.play("attack")
	
	var miner_projectile = miner_projectile_scene.instantiate()
	miner_projectile.global_position = global_position
	
	if direction != Vector2.ZERO:
		miner_projectile.rotation = direction.angle()
	miner_projectile.direction = direction
	
	animated_sprite.flip_h = direction.x > 0
	
	get_tree().current_scene.add_child(miner_projectile)
	start_cooldown_shot()


func start_cooldown_shot() -> void:
	await get_tree().create_timer(cooldown_shot).timeout
	can_shoot = true
	if is_attacking and player:
		shoot_projectile(player.global_position - global_position)
	elif player != null:
		can_shoot = true
		is_attacking = false
		can_moving = true


func _on_animated_sprite_finished() -> void:
	if animated_sprite.animation == "death":
		var coin: Area2D = coins.instantiate()
		coin.position = global_position
		get_tree().current_scene.add_child(coin)
		queue_free()
