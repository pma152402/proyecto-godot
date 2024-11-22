extends CharacterBody2D

const velocidad = 100.0
const velocidad_salto = -500.0
const multiplicador_correr = 2.0

var vida_jugador = 100
#signal cambiar_vida(nueva_vida) # como un metodo al que le cambiare la vida en el zombi

# CAMBIAR VIDA Y DETECTAR SI ESTA MUERTO
func cambiar_vida(modificar_vida):
	if vida_jugador <= 0:
		#await get_tree().create_timer(1.1).timeout
		$Sprite2D.modulate = Color(0, 1, 0, 1)
		

func _ready():
	$AnimationPlayer.connect("animation_finished", Callable(self, "_on_animation_finished"))


func _physics_process(delta: float) -> void:
	# GRAVEDAD
	if not is_on_floor():
		velocity += get_gravity() * delta

	# SALTAR
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = velocidad_salto

	# DETECTAR MOVIMIENTO HORIZONTAL
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		# Determinar si el jugador está corriendo
		var is_running := Input.is_action_pressed("correr")
		var current_speed := velocidad
		if is_running:
			current_speed *= multiplicador_correr  # Aumentar velocidad al correr

		velocity.x = direction * current_speed

		# Cambiar animaciones según el estado (correr tiene prioridad)
		if is_running:
			if $AnimationPlayer.current_animation != "running":
				$AnimationPlayer.play("running")
		else:
			if $AnimationPlayer.current_animation != "waling":
				$AnimationPlayer.play("waling")

		# Girar a la izquierda o derecha
		$Sprite2D.scale.x = -1 if direction < 0 else 1
	else:
		# ESTAR QUIETO
		velocity.x = move_toward(velocity.x, 0, velocidad)
		if $AnimationPlayer.current_animation != "idle" and $AnimationPlayer.current_animation != "shooting":
			$AnimationPlayer.play("idle")

	# MOVER AL JUGADOR
	move_and_slide()
	
	# APUNTAR
	var apuntar := Input.is_action_pressed("aiming")
	if apuntar and $AnimationPlayer.current_animation != "waling" and $AnimationPlayer.current_animation != "running" and $AnimationPlayer.current_animation != "shooting":
		$AnimationPlayer.play("aiming")

	# DISPARAR
	var disparar := Input.is_action_just_pressed("shooting")
	if apuntar and disparar and $AnimationPlayer.current_animation != "shooting":
		$AnimationPlayer.play("shooting")
	### ESTO TENGO QUE REVISARLO PORQUE HE CAMBIADO LA ANIMACION PORQUE NO PASA DEL PRIMER FRAME
	
