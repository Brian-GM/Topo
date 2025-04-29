extends CharacterBody2D


var animated_sprite: AnimatedSprite2D
var collision_shape: CollisionShape2D

var movement_speed: float = 120.0
var can_moving: bool = true
var is_moving: bool = false
var is_chasing: bool = false
var current_point_index: int = 0

var navigation_agent: NavigationAgent2D

var player: Node2D = null
var detect_player: Area2D

var atack_area_1:Area2D
var atack_area_2:Area2D

var is_atack_1: bool = false
var is_atack_2: bool = false

var damage_zone_1: Area2D
var damage_zone_2: Area2D

@onready var danger_atack_area_1: Sprite2D = $Atack1/AtackArea1/DangerAtackArea1

@onready var danger_atack_area_2: Sprite2D = $Atack2/AtackArea2/DangerAtackArea2

@onready var atack_1_animation: AnimatedSprite2D = $Atack1

@onready var atack_2_animation: AnimatedSprite2D = $Atack2

#var health: int = 25
var health: int = 2
var damage: int = 1

var atack_1_bodies
var atack_2_bodies

var is_dying: bool = false


func _ready():
	danger_atack_area_1.visible = false
	danger_atack_area_2.visible = false
	
	animated_sprite = get_node("AnimatedSprite2D")
	navigation_agent = get_node("NavigationAgent2D")
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	
	detect_player = get_node("DetectPlayer")
	atack_area_1 = get_node("Atack1/AtackArea1")
	atack_area_2 = get_node("Atack2/AtackArea2")
	
	collision_shape = get_node("DetectPlayer/CollisionShape2D")
	collision_shape.shape.set("radius", (get_viewport_rect().size.x / 2))	


func _process(_delta):
	if is_dying:
		return
	
	if player:
		navigation_agent.target_position = player.global_position
	else:
		var bodies = detect_player.get_overlapping_bodies()
		if bodies and bodies.size() > 0:
			for body in bodies:
				if body.is_in_group("player"):
					player = body
	
	# Ataque 1 
	if !is_atack_1:
		atack_1_bodies = atack_area_1.get_overlapping_bodies()
		if atack_1_bodies and atack_1_bodies.size() > 0:
			for body in atack_1_bodies:
				if body.is_in_group("player") and !is_atack_1:
					atack_1()
	
	# Ataque 2
	if !is_atack_2:
		atack_2_bodies = atack_area_2.get_overlapping_bodies()
		if atack_2_bodies and atack_2_bodies.size() > 0:
			for body in atack_2_bodies:
				if body.is_in_group("player") and !is_atack_2:
					atack_2()


func _physics_process(_delta):
	if GameManager.is_cinematic_active or !can_moving or is_dying:
		return
	
	is_moving = velocity.length() != 0
	
	if is_moving:
	# Flip el sprite horizontalmente si va a la izquierda
		animated_sprite.flip_h = velocity.x < 0
		atack_2_animation.flip_h = velocity.x < 0
		#var direction = velocity.normalized() 
		#atack_2_animation.rotation = direction.angle() + PI + 90
		if !is_atack_2:
			atack_2_animation.look_at(player.global_position) 
			atack_2_animation.rotate(deg_to_rad(-90))
	
	
	if navigation_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return
	
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()


func atack_1():
	if is_dying:
		return
	
	is_atack_1 = true
	can_moving = false
	
	animated_sprite.play("atack")
	danger_atack_area_1.visible = true
	await get_tree().create_timer(0.25).timeout
	atack_1_animation.play("atack1")
	await get_tree().create_timer(0.25).timeout
	
	if atack_1_bodies and atack_1_bodies.size() > 0:
		for body in atack_1_bodies:
			if body.is_in_group("player"):
				player.call_deferred("damage",damage)
			
			danger_atack_area_1.visible = false
			$Atack1_Cooldown.start(10)
			$Atack1/AtackArea1/CollisionShape2D.disabled = true
			
			AudioManager.play_sound("putaso_piedra.mp3", 0.0, false, 0.0, 0.3)
			
			await get_tree().create_timer(0.5).timeout
			can_moving = true
			animated_sprite.play("walk")


func atack_2():
	if is_dying:
		return
	
	is_atack_2 = true
	can_moving = false
	
	animated_sprite.play("atack")
	danger_atack_area_2.visible = true
	await get_tree().create_timer(0.25).timeout
	atack_2_animation.play("atack2")
	await get_tree().create_timer(0.25).timeout
	
	if atack_2_bodies and atack_2_bodies.size() > 0:
		for body in atack_2_bodies:
			if body.is_in_group("player"):
				player.call_deferred("damage",damage)
			danger_atack_area_2.visible = false
			$Atack2_Cooldown.start(7)
			$Atack2/AtackArea2/CollisionShape2D.disabled = true
			
			AudioManager.play_sound("putaso_piedra.mp3", 0.0, false, 0.0, 0.3)
			await get_tree().create_timer(0.5).timeout
			can_moving = true
			animated_sprite.play("walk")


func get_damaged() -> void:
	health -= GameManager.player_attack
	if health <= 0:
		is_dying = true
		
		AudioManager.play_sound("golem_death.mp3", 0.0, false, 0.0, 0.3)
		animated_sprite.play("death")
		await animated_sprite.animation_finished
		
		if AudioManager.audio_stream_players.has("golem_death.mp3"):
			await (AudioManager.audio_stream_players["golem_death.mp3"] as AudioStreamPlayer).finished
			
		AudioManager.stop("GabMetal_Def.mp3", 1)
		get_tree().change_scene_to_file("res://Scenes/Levels/LoadingScene/loading_scene.tscn")


func _on_atack_1_cooldown_timeout() -> void:
	if is_dying:
		return
	
	is_atack_1 = false
	$Atack1/AtackArea1/CollisionShape2D.disabled = false


func _on_atack_2_cooldown_timeout() -> void:
	if is_dying:
		return
	
	is_atack_2 = false
	$Atack2/AtackArea2/CollisionShape2D.disabled = false
