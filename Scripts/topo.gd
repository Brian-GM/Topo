extends CharacterBody2D

@export var projectile_scene: PackedScene  
@export var zarpazo_scene: PackedScene
var posicion_raton

var vida : int = GameManager.vida_personaje
var speed: float = GameManager.velocidad_personaje
var zarpazo_cooldown: float = GameManager.cooldown_garra
var disparo_cooldown: float = GameManager.cooldown_disparo

var puede_zarpazo := true
var puede_disparar := true
var cama_en_rango: Node = null
var agujero_en_rango: Node = null
var exp_en_rango: Node = null

var animacion_forzada: bool = false


func _ready() -> void:
	$AnimatedSprite2D.play("idle")
	add_to_group("player")

func _process(delta: float) -> void:
	
	posicion_raton = get_global_mouse_position() - global_position
	
	# Movimiento del personaje
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_axis("movimiento_izquierda", "movimiento_derecha")
	input_vector.y = Input.get_axis("movimiento_arriba", "movimiento_abajo")

	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		velocity = input_vector * speed
	else:
		velocity = Vector2.ZERO

	# Animación de movimiento
	if not animacion_forzada:
		if velocity != Vector2.ZERO:
			$AnimatedSprite2D.play("run")
		else:
			$AnimatedSprite2D.play("idle")

	# Activar el golpe de garra al presionar "Golpear"
	if Input.is_action_just_pressed("Golpear") and puede_zarpazo:
		animacion_forzada = true
		if input_vector != Vector2.ZERO:
			$AnimatedSprite2D.play("garra_correr")
		else:
			$AnimatedSprite2D.play("ataque")
		realizar_zarpazo(posicion_raton)
		puede_zarpazo = false
		start_zarpazo_cooldown()
		await $AnimatedSprite2D.animation_finished
		animacion_forzada = false

	if Input.is_action_just_pressed("Disparar") and puede_disparar:
		animacion_forzada = true
		if input_vector != Vector2.ZERO:
			$AnimatedSprite2D.play("piedra_correr")
		else:
			$AnimatedSprite2D.play("ataque_piedra")
		shoot_projectile(posicion_raton)
		puede_disparar = false
		start_disparo_cooldown()
		await $AnimatedSprite2D.animation_finished
		animacion_forzada = false

	move_and_slide()
	
	if cama_en_rango and Input.is_action_just_pressed("Interactuar"):
		curarse()
	
	if agujero_en_rango and Input.is_action_just_pressed("Interactuar"):
		pasar_nivel()

# Función para disparar el proyectil
func shoot_projectile(direction: Vector2):
	var projectile = projectile_scene.instantiate()
	projectile.global_position = global_position
	if direction != Vector2.ZERO:
		projectile.rotation = direction.angle()
	projectile.direction = direction
	get_tree().current_scene.add_child(projectile)

func realizar_zarpazo(direction: Vector2):
	var zarpazo = zarpazo_scene.instantiate()
	zarpazo.global_position = global_position
	if direction != Vector2.ZERO:
		zarpazo.rotation = direction.angle()
	get_tree().current_scene.add_child(zarpazo)

func start_zarpazo_cooldown() -> void:
	await get_tree().create_timer(zarpazo_cooldown).timeout
	puede_zarpazo = true

func start_disparo_cooldown() -> void:
	await get_tree().create_timer(disparo_cooldown).timeout
	puede_disparar = true

func entrar_en_rango_de_cama(cama: Node):
	cama_en_rango = cama

func salir_de_rango_de_cama():
	cama_en_rango = null

func entrar_en_rango_agujero(agujero: Node):
	agujero_en_rango = agujero

func salir_de_rango_agujero():
	agujero_en_rango = null

func entrar_exp_en_rango(exp: Node):
	exp_en_rango = exp

func salir_exp_en_rango():
	exp_en_rango = null

func curarse():
	vida += GameManager.recuperacion

func pasar_nivel():
	get_tree().change_scene_to_file("res://Escenas/nivelcarga.tscn")

func Golpe():
	print("h")
	vida -= 1
	if vida == 0:
		Morir()

func Morir():
	queue_free()
