extends WormStateGravityBase

var patrol_speed = 30.0
var direction = 1  # 1 para derecha, -1 para izquierda
var patrol_time = 5.0  # Tiempo que patrulla en una dirección
var timer = 0.0
var animation_started = false

func start():
	super.start()
	worm.change_sprite_visibility("SpriteWalk")
	timer = 0.0  # Reiniciar temporizador
	
	# Establecer dirección inicial aleatoria
	direction = 1 if randf() > 0.5 else -1
	worm.sprite_walk.flip_h = (direction < 0)
	animation_started = false

func physics_update(delta: float): 
	super.physics_update(delta)
	if not animation_started:
		worm.play_animation(worm.animations.WALK)
		animation_started = true	
	# Actualizar temporizador
	timer += delta
	
	# Comprobar si hay suelo adelante
	if not check_floor_ahead():
		change_direction()
	
	# Cambiar dirección después de cierto tiempo
	if timer >= patrol_time:
		change_direction()
		timer = 0.0
	
	# Mover al enemigo
	worm.velocity.x = direction * patrol_speed

func check_floor_ahead():
	# Crear un raycast para verificar si hay suelo adelante
	var raycast = RayCast2D.new()
	worm.add_child(raycast)
	
	# Posicionar el raycast justo adelante del borde del sprite
	var offset = 15  # Ajusta según el tamaño de tu sprite
	raycast.position = Vector2(direction * offset, 0)
	raycast.target_position = Vector2(0, 20)  # Raycast hacia abajo
	raycast.enabled = true
	raycast.force_raycast_update()
	
	var has_floor = raycast.is_colliding()
	
	# Limpiar raycast temporal
	worm.remove_child(raycast)
	raycast.queue_free()
	
	return has_floor

func change_direction():
	direction *= -1  # Invertir dirección
	worm.sprite_walk.flip_h = (direction < 0)  # Voltear sprite según dirección
