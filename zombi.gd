extends CharacterBody2D

var velocidad = 40.0
const velocidad_salto = -300.0
const velocidad_andando = 40
const velocidad_corriendo = 100
const gravedad = 980

var jugador = null

func _ready():
	jugador = get_node("../Jugador")
	if jugador == null:
		print("fallo la ruta del jugador")
	
func follow():
	if jugador != null:
		velocity = position.direction_to(jugador.position) * velocidad
	
# ATACAR Y CAMBIAR VIDA AL JUGADOR
func atacar_jugador(int):
	if jugador:
		jugador.cambiar_vida(int)

func _physics_process(delta: float) -> void:
	#Aplicar gravedad
	if not is_on_floor():
		position.y += gravedad * delta
	#else:
	#	if velocity.y > 0:	#si esta cayendo
	#		velocity.y = 0  #detengo la velocidad
	
	follow()
	move_and_slide()

	# ANIMACION DE CAMINAR
	# CAMBIAR DIRECCION 
	$Sprite2D.scale.x = -1 if jugador.position.x < position.x else 1
	
	# PERSEGUIR DE CERCA
	if abs(position.x - jugador.position.x) < 200:		# 300?
	
		
		# SI ESTA JUSTO AL LADO ATACA raro
		var jugador_shape_size = jugador.get_node("CollisionShape2D").shape.size.x 
		if abs(position.x - jugador.position.x) < jugador_shape_size:
		
		# SI ESTA JUSTO AL LADO ATACA
			if abs(position.x - jugador.position.x) < 15:
				$AnimationPlayer.play("attack")
			
			# Cambiar color a rojo
			# Esperamos un poco para que coincida con el mordisco
			await get_tree().create_timer(1.1).timeout
			jugador.get_node("Sprite2D").modulate = Color(1, 0.5, 0.5, 1)
			# Esperamos un segundo
			await get_tree().create_timer(0.5).timeout
			
			# LE BAJA VIDA AL JUGADOR
			atacar_jugador(80)
			
			# Volvemos al color original
			jugador.get_node("Sprite2D").modulate = Color(1, 1, 1, 1)
			

		# SINO, SIGUE CORRIENDO
		else:
			if $AnimationPlayer.current_animation != "running":
				velocidad = velocidad_corriendo
				$AnimationPlayer.play("running")
			
	# VOLVER A ANDAR
	else:
		if $AnimationPlayer.current_animation != "walking":
			velocidad = velocidad_andando
			$AnimationPlayer.play("walking")
	
	
	
	
