extends CharacterBody2D


var animated_sprite: AnimatedSprite2D
var collision_shape: CollisionShape2D
var movement_speed: float = 150.0

var can_moving: bool = true
var is_moving: bool = false
var is_chasing: bool = false
var current_point_index: int = 0

var navigation_agent: NavigationAgent2D

var player: Node2D = null
var health:int = 5
var damage:int = 1
var atack_area 
var is_atack:bool = false

func _ready():
	animated_sprite = get_node("AnimatedSprite2D")
	navigation_agent = get_node("NavigationAgent2D")
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	
	collision_shape = get_node("DetectPlayer/CollisionShape2D")
	collision_shape.shape.set("radius", (get_viewport_rect().size.x / 2))
	
	atack_area = get_node("AtackArea")
	
	is_chasing = false
	
	animated_sprite.play("walk")


func _process(_delta):
	if is_chasing and player:
		navigation_agent.target_position = player.global_position

	var bodies_2 = atack_area.get_overlapping_bodies()
	if bodies_2 and bodies_2.size() > 0:
		for body in bodies_2:
			if body.is_in_group("player") and !is_atack:
				atack_melee()
				
func atack_melee():
	animated_sprite.play("atack")
	AudioManager.play_sound("cangrejoputaso.mp3",0.0,false,0.0,0.3)
	player.call_deferred("damage",damage)
	is_atack = true					
			
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
	health -= GameManager.player_attack
	if health <= 0:
		animated_sprite.play("death")


func _on_detect_player_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		is_chasing = true


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "atack":
		animated_sprite.play("walk")
		$Atack_Cooldown.start(2)
	if animated_sprite.animation == "death":
		queue_free()


func _on_atack_cooldown_timeout() -> void:
	is_atack = false
