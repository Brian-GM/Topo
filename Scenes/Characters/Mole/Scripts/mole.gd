extends CharacterBody2D

var projectile_scene: PackedScene  
var swipe_scene: PackedScene
var mouse_position: Vector2

var speed: float = GameManager.player_velocity
var cooldown_claw: float = GameManager.player_cooldown_claw
var cooldown_shot: float = GameManager.player_cooldown_shot

var can_swipe := true
var can_shoot := true
var bed_in_range: Node = null
var hole_in_range: Node = null
var exp_in_range: Node = null
var store_in_range: Node = null

var forced_animation: bool = false

var animated_sprite: AnimatedSprite2D


func _ready() -> void:
	animated_sprite = get_node("MoleSprite")
	animated_sprite.play("idle")
	
	projectile_scene = preload("res://Scenes/Characters/Projectile/projectile.tscn")
	swipe_scene = preload("res://Scenes/Characters/Swipe/swipe.tscn")


func _process(_delta: float) -> void:
	mouse_position = get_global_mouse_position() - global_position
	
	# Movimiento del personaje
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_axis("move_left", "move_right")
	input_vector.y = Input.get_axis("move_up", "move_down")
	
	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		velocity = input_vector * speed
	else:
		velocity = Vector2.ZERO
	
	if input_vector.x > 0:
		animated_sprite.flip_h = true
	elif input_vector.x < 0:
		animated_sprite.flip_h = false
	
	# Animación de movimiento
	if not forced_animation:
		if velocity != Vector2.ZERO:
			animated_sprite.play("run")
		else:
			animated_sprite.play("idle")
	
	# Activar el golpe de garra al presionar "Golpear"
	if Input.is_action_just_pressed("attack") and can_swipe:
		forced_animation = true
		if input_vector != Vector2.ZERO:
			animated_sprite.play("garra_correr")
		else:
			animated_sprite.play("ataque")
		make_swipe(mouse_position)
		can_swipe = false
		start_cooldown_claw()
		AudioManager.play_sound("Sonido de Zarpazo al aire 1 - Efecto de Sonido.mp3",0.0,false,0.0,0.3)
		await animated_sprite.animation_finished
		forced_animation = false
	
	if Input.is_action_just_pressed("shoot") and can_shoot:
		forced_animation = true
		if input_vector != Vector2.ZERO:
			animated_sprite.play("piedra_correr")
		else:
			animated_sprite.play("ataque_piedra")
		shoot_projectile(mouse_position)
		can_shoot = false
		start_cooldown_shot()
		AudioManager.play_sound("Efecto de Sonido de TIRAR.mp3",0.0,false,0.0,0.3)
		await animated_sprite.animation_finished
		forced_animation = false
	move_and_slide()
	
	if bed_in_range and Input.is_action_just_pressed("interact"):
		heal()
	
	if hole_in_range and Input.is_action_just_pressed("interact"):
		pasar_nivel()
	
	if exp_in_range and Input.is_action_just_pressed("interact"):
		exp_shop()
		
	if store_in_range and Input.is_action_just_pressed("interact"):
		store()


# Función para disparar el proyectil
func shoot_projectile(direction: Vector2):
	var projectile = projectile_scene.instantiate()
	projectile.global_position = global_position
	if direction != Vector2.ZERO:
		projectile.rotation = direction.angle()
	projectile.direction = direction
	get_tree().current_scene.add_child(projectile)


func make_swipe(direction: Vector2):
	var zarpazo = swipe_scene.instantiate()
	zarpazo.global_position = global_position
	if direction != Vector2.ZERO:
		zarpazo.rotation = direction.angle()
	get_tree().current_scene.add_child(zarpazo)


func start_cooldown_claw() -> void:
	await get_tree().create_timer(cooldown_claw).timeout
	can_swipe = true


func start_cooldown_shot() -> void:
	await get_tree().create_timer(cooldown_shot).timeout
	can_shoot = true


func enter_bed_range(cama: Node):
	bed_in_range = cama


func exited_bed_range():
	bed_in_range = null


func enter_hole_range(agujero: Node):
	hole_in_range = agujero


func exited_hole_range():
	hole_in_range = null


func enter_exp_range(exp_node: Node):
	exp_in_range = exp_node


func exited_exp_range():
	exp_in_range = null


func enter_store_range(exp_node: Node):
	store_in_range = exp_node


func exited_store_range():
	store_in_range = null


func heal():
	GameManager.player_life += GameManager.MAX_PLAYER_LIFE/3
	AudioManager.play_sound("Health.mp3",0.0,false,0.0,1)



func pasar_nivel():
	get_tree().change_scene_to_file("res://Scenes/Levels/LoadingScene/loading_scene.tscn")


func exp_shop():
	get_tree().change_scene_to_file("res://Scenes/Levels/Shop/shop_exp.tscn")


func store():
	get_tree().change_scene_to_file("res://Scenes/Levels/Shop/shop_exp.tscn")


func damage(total_damage: int = 1):
	GameManager.player_life -= total_damage
	AudioManager.play_sound("takedamage.mp3",0.0,false,0.0,1)
	if GameManager.player_life < 0:
		die()

func die():
	GameManager.game_over()
