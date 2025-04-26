extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -400.0
const MAX_LEAN_ANGLE = 0.5
const LEAN_SPEED = 5.0
const FALL_SPEED = 350.0  # Velocidad de caída constante (siempre hacia abajo)

var target_lean = 0.0
var horizontal_velocity = 0.0

var camera: Camera2D


func _ready() -> void:
	camera = get_node("Camera2D")
	camera.limit_left = 0
	camera.limit_right = 1283


func _physics_process(delta: float) -> void:
	# Velocidad vertical constante (sin aceleración por gravedad)
	velocity.y = FALL_SPEED  # Siempre cae a esta velocidad fija
	
	# Movimiento horizontal (independiente de la caída)
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		horizontal_velocity = direction * SPEED
		target_lean = -direction * MAX_LEAN_ANGLE
	else:
		horizontal_velocity = 0
		target_lean = 0.0
	
	# Aplicar velocidad horizontal
	velocity.x = horizontal_velocity
	
	# Inclinación suave
	rotation = lerp(rotation, target_lean, LEAN_SPEED * delta)
	
	move_and_slide()
