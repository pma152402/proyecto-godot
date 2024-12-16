extends CharacterBody2D

var velocidad = 40.0
const velocidad_salto = -300.0
const velocidad_andando = 40
const velocidad_corriendo = 100
const gravedad = 980

var jugador = null

var animacion_anterior = ""

# LOCALIZAR AL JUGADOR
func _ready():
	jugador = get_node("../Jugador")
	if jugador == null:
		print("fallo la ruta del jugador")
	
	$AnimationPlayer.animation_changed.connect(_on_animation_player_animation_changed)
	
	
# PERSEGUIR AL JUGADOR
func follow():
	if jugador != null:
		velocity = position.direction_to(jugador.position) * velocidad
	
	
	
	
# ATACAR Y CAMBIAR VIDA AL JUGADOR
#func _on_AnimationPlayer_animation_finished(nombre_animacion):
#	if nombre_animacion == "attack":
#		atacar_jugador()
#d	print("nuria envidiosa")
		



#func atacar_jugador():
#	$AnimationPlayer.play("attack")
#	print(jugador.vida_jugador)
#	print("zombie atacando")
	
		
#	if $AnimationPlayer.current_animation == "attack":
#		jugador.cambiar_vida(10)
		


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
			if abs(position.x - jugador.position.x) < 15: #and abs(position.y - jugador.position.y) < 1:
				$AnimationPlayer.play("attack")
			# Esperamos un poco para que coincida con el mordisco
				await get_tree().create_timer(1.1).timeout
			# Cambio el color a rojo
				jugador.get_node("Sprite2D").modulate = Color(1, 0.5, 0.5, 1)
			# Esperamos medio segundo
				await get_tree().create_timer(0.5).timeout
			# LE BAJA VIDA AL JUGADOR
#				atacar_jugador()  # funciona pero le hace daño desde muy lejos y a veces de cerca no
				#print("acaba de atacar")
				
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
	
	
	
	



func _on_animation_player_animation_changed(nueva_animacion: StringName) -> void:
	print("Animacion anterior: ", animacion_anterior)
	print("Nueva animacion: ", nueva_animacion)
	if animacion_anterior == "attack" and nueva_animacion != "attack":
		jugador.cambiar_vida(10)
		print("nuevo metodo")
		
	animacion_anterior = nueva_animacion
