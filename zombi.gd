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
		print("illo q pasa")
	
	
	
func follow():
	if jugador != null:
		velocity = position.direction_to(jugador.position) * velocidad
	
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
		#var jugador_shape_size = jugador.get_node("CollisionShape2D").shape.size.x 
		#if abs(position.x - jugador.position.x) < jugador_shape_size:
		
		# SI ESTA JUSTO AL LADO ATACA
		if abs(position.x - jugador.position.x) < 15:
			$AnimationPlayer.play("attack")
			
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
	
	
	
	
