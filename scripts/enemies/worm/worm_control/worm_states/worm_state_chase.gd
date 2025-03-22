extends WormStateGravityBase

var chase_speed = worm.movement_stats.CHASE_SPEED 
var chase_timer = worm.movement_stats.CHASE_TIME
var attack_range = worm.movement_stats.ATTACK_RANGE
var animation_started = false
var timer = 0.0
var direction = 0

func start():
	super.start()
	worm.change_sprite_visibility("SpriteWalk")
	timer = 0.0  # Reiniciar temporizador
	# Establecer dirección inicial aleatoria
	if worm.facing_direction != 0:
		direction = worm.facing_direction
	else:
		direction = 1 if randf() > 0.5 else -1
		worm.facing_direction = direction
		
	worm.set_facing_direction(direction)
	animation_started = false
	
func physics_update(delta: float):	
	super.physics_update(delta)
	if not animation_started:
		worm.play_animation(worm.animations.WALK)
		animation_started = true	
	var player = worm.detect_player()
	if player and worm.is_in_attack_range(player):		
		state_machine.change_to(worm.states.Attack)	
	elif timer >= chase_timer:
		state_machine.change_to(worm.states.Idle)
	elif player:
		chase(delta, player)
	else: 
		timer += delta
		
func chase(delta, player):
	# Actualizar temporizador
	timer += delta
	
	# Obtener la diferencia horizontal
	var x_diff = player.global_position.x - worm.global_position.x
	
	# Determinar dirección con zona muerta
	if abs(x_diff) > 20:
		var chase_direction = 1 if x_diff > 0 else -1
		
		if chase_direction != worm.facing_direction:
			worm.facing_direction = chase_direction
			worm.set_facing_direction(chase_direction)
	
	# COMPORTAMIENTO SEGURO: Verificar el suelo antes de moverse
	var safe_to_move = true
	
	# Verificar explícitamente si hay suelo en la dirección actual
	if worm.facing_direction > 0:
		safe_to_move = worm.floor_check_right.is_colliding()
	else:
		safe_to_move = worm.floor_check_left.is_colliding()
	
	
	if safe_to_move:
		worm.velocity.x = worm.facing_direction * chase_speed
	else:
		# Detener completamente si no es seguro
		worm.velocity.x = 0
