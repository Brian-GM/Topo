extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -400.0
const MAX_LEAN_ANGLE = 0.5
const LEAN_SPEED = 5.0
const FALL_SPEED = 350.0  # Velocidad de caída constante (siempre hacia abajo)

var target_lean = 0.0
var horizontal_velocity = 0.0

	
func _physics_process(delta: float) -> void:
	# Velocidad vertical constante (sin aceleración por gravedad)
	if not is_on_floor():
		velocity.y = FALL_SPEED  # Siempre cae a esta velocidad fija
	else:
		velocity.y = 0  # En el suelo, no hay movimiento vertical

	# Salto (anula la caída momentáneamente)
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movimiento horizontal (independiente de la caída)
	var direction := Input.get_axis("ui_left", "ui_right")
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

#
#func _on_oro_body_entered(body: Node2D) -> void:
	#ororecogido += 1
	#%cantidad_oro.set_text(str(ororecogido))
	#print("Oro Recogido - "+str(ororecogido))
