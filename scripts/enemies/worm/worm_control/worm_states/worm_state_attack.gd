extends WormStateGravityBase
var animation_started = false
var attack_duration = 0.8  # Duración de la animación de ataque
var timer = 0.0

func start():
	super.start()
	worm.change_sprite_visibility("SpriteAttack")
	animation_started = false
	timer = 0.0
	
	# Usar las funciones centralizadas para encontrar al jugador y orientarse
a 	var player = worm.detect_player()
	if player:
		# Determinar dirección hacia el jugador
		var direction = 1 if player.global_position.x > worm.global_position.x else -1
		worm.set_facing_direction(direction)

func physics_update(delta: float): 
	super.physics_update(delta)
	
	# Iniciar la animación solo una vez
	if not animation_started:
		worm.play_animation(worm.animations.ATTACK)
		animation_started = true
	
	# Detener movimiento durante el ataque
	worm.velocity.x = 0
	
	# Controlar el tiempo del ataque
	timer += delta
	if timer >= attack_duration:
		# Volver a estado de patrulla cuando termine el ataque
		state_machine.change_to("WormEnemyStatePatrol")
		
func detect_player(detection_range: float = 150.0):
	# Buscar al jugador en el grupo "player"
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		var player = players[0]
		var distance = worm.global_position.distance_to(player.global_position)
		if distance < detection_range:
			return player
	return null

func is_in_attack_range(player, attack_range: float = 40.0):
	if player:
		var distance = worm.global_position.distance_to(player.global_position)
		return distance < attack_range
	return false
	
func chase_player(player, chase_speed: float = 50.0):
	pass
	#if player:
		## Determinar dirección hacia el jugador
		#var player_direction = 1 
		#if player.global_position.x > global_position.x else -1
		#
		## Voltear sprite según dirección
		#worm.set_facing_direction(player_direction)
		#
		## Comprobar si hay suelo adelante antes de moverse
		#if worm.check_floor_ahead(player_direction):
			## Mover hacia el jugador
			#velocity.x = player_direction * chase_speed
			#return true
		#else:
			## Si no hay suelo, detener movimiento
			#velocity.x = 0
			#return false
	#return false
