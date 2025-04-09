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


func _ready() -> void:
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

	# Activar el golpe de garra al presionar "Golpear"
	if Input.is_action_just_pressed("Golpear") and puede_zarpazo:
		realizar_zarpazo(posicion_raton)
		puede_zarpazo = false
		start_zarpazo_cooldown()

	if Input.is_action_just_pressed("Disparar") and puede_disparar:
		shoot_projectile(posicion_raton)
		puede_disparar = false
		start_disparo_cooldown()

	move_and_slide()
	
	
	if cama_en_rango and Input.is_action_just_pressed("Interactuar"):
		curarse()

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

func curarse():
	vida += GameManager.recuperacion

func Golpe():
	print("h")
	vida -= 1
	if vida == 0:
		Morir()

func Morir():
	queue_free()
