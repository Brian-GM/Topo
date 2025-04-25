extends CharacterBody2D
const Barrel = preload("res://Scenes/Characters/Barrel/barrel.tscn")

#const GOBLIN_TORCH = preload("res://Scenes/Characters/GoblinTorch/goblin_torch.tscn")
#
#const PIMPOLLO = preload("res://Scenes/Characters/Pimpollo/pimpollo.tscn")

var enemies = [Barrel]

var animated_sprite: AnimatedSprite2D
var collision_shape: CollisionShape2D

var is_exploting: bool = false

var movement_speed: float = 200.0

var can_moving: bool = true
var is_moving: bool = false
var is_chasing: bool = false
var current_point_index: int = 0

var navigation_agent: NavigationAgent2D

var player: Node2D = null
var detect_player: Area2D
var atack_area:Area2D
var is_atack: bool = false
var damage_zone: Area2D

var health:int = 25
var damage:int = 1

func _ready():
	animated_sprite = get_node("AnimatedSprite2D")
	navigation_agent = get_node("NavigationAgent2D")
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0

	detect_player = get_node("DetectPlayer")
	atack_area = get_node("AtackArea")

				
	collision_shape = get_node("DetectPlayer/CollisionShape2D")
	collision_shape.shape.set("radius", (get_viewport_rect().size.x / 2))	
	animated_sprite.play("walk")
	

func _process(_delta):
	
	if player:
		navigation_agent.target_position = player.global_position
	else:
		var bodies = detect_player.get_overlapping_bodies()
		if bodies and bodies.size() > 0:
			for body in bodies:
				if body.is_in_group("player"):
					player = body
					
	var bodies_2 = atack_area.get_overlapping_bodies()
	if bodies_2 and bodies_2.size() > 0:
		for body in bodies_2:
			if body.is_in_group("player") and !is_atack:
				atack_melee()
				


						


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



func summon():
	var background_layer: TileMapLayer = get_tree().current_scene.get_node("Map/Spawn")
	
	var used_cells = background_layer.get_used_cells()
	if used_cells.size() < 3:
		return
	
	
	used_cells.shuffle()
	
	var random_position_spawn_1 = (background_layer.map_to_local(used_cells[0]))
	var random_position_spawn_2 = (background_layer.map_to_local(used_cells[1]))
	var random_position_spawn_3 = (background_layer.map_to_local(used_cells[2]))
	var random_enemy_1: Node2D
	var random_enemy_2: Node2D
	var random_enemy_3: Node2D
	
	var random_position_spawn = [random_position_spawn_1, random_position_spawn_2, random_position_spawn_3]
	
	enemies.shuffle()
	
	random_enemy_1 = enemies[0].instantiate()
	
	enemies.shuffle()
	
	random_enemy_2 = enemies[0].instantiate()
	
	enemies.shuffle()
	
	random_enemy_3 = enemies[0].instantiate()
	
	random_enemy_1.position = random_position_spawn[0]
	random_enemy_2.position = random_position_spawn[1]
	random_enemy_3.position = random_position_spawn[2]
	
	get_parent().add_child(random_enemy_1)
	#random_enemy_1.connect("has_die", _on_enemy_die)
	#random_enemy_2.connect("has_die", _on_enemy_die)
	#random_enemy_3.connect("has_die", _on_enemy_die)
	
	#
	#if enemies_has_summon == 0:
		#get_parent().add_child(random_enemy_1)
		#get_parent().add_child(random_enemy_2)
		#get_parent().add_child(random_enemy_3)
	#elif enemies_has_summon == 1:
		#get_parent().add_child(random_enemy_1)
		#get_parent().add_child(random_enemy_2)
	#elif enemies_has_summon == 2:
		#get_parent().add_child(random_enemy_1)
	#
	#enemies_has_summon = 3
	

#func _on_animated_sprite_finished() -> void:
	#if animated_sprite.animation == "death":
		#get_tree().change_scene_to_file("")
		#if bodies and bodies.size() > 0:
			#for body in bodies:
				#if body.is_in_group("player"):
					#player.call_deferred("damage")


func atack_melee():
	animated_sprite.play("atack1")
	is_atack = true					
	player.call_deferred("damage",damage)


func get_damaged() -> void:
	health -= GameManager.player_attack
	if health <= 0:
		GameManager.finish_game()
		
	
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "atack2":
		print("Invocacion finalizada")
		can_moving = true
		is_atack = false
		animated_sprite.play("walk")
		$Atack2_Cooldown.start(10)
	elif animated_sprite.animation == "atack1":
		print("Ataque 1 terminado")
		can_moving = true
		animated_sprite.play("walk")
		$Atack1_Cooldown.start(2)


func _on_atack_1_cooldown_timeout() -> void:
	is_atack = false

func _on_atack_2_cooldown_timeout() -> void:
	if !is_atack:
		animated_sprite.play("atack2")
		is_atack = true
		can_moving = false
		summon()
	else:
		$Atack2_Cooldown.start(10)
