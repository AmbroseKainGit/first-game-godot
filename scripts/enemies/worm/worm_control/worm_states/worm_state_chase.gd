extends WormStateGravityBase

var chase_speed = worm.movement_stats.CHASE_SPEED 
var chase_timer = worm.movement_stats.CHASE_TIME
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
		
	worm.sprite_walk.flip_h = (direction < 0)
	animation_started = false
	
func physics_update(delta: float):	
	super.physics_update(delta)		
		 
	if not animation_started:
		worm.play_animation(worm.animations.WALK)
		animation_started = true
	var player = detect_player()
	if player:
		chase(delta, player)		
	# Cambiar a estado de patrulla cuando el temporizador alcance el tiempo definido
	
	if timer >= chase_timer:
		state_machine.change_to(worm.states.Idle)
		
func chase(delta, player):
	# Actualizar temporizador
	timer += delta
	
	# Determinar la dirección hacia el jugador
	var chase_direction = 1 if player.global_position.x > worm.global_position.x else -1
	
	# Actualizar la dirección del enemigo
	worm.facing_direction = chase_direction
	worm.sprite_walk.flip_h = (chase_direction < 0)
	
	# Verificar si hay suelo en la dirección de persecución
	if worm.check_floor_ahead(chase_direction):
		# Mover al enemigo hacia el jugador
		worm.velocity.x = chase_direction * chase_speed
	else:
		# Si no hay suelo, detenerse
		worm.velocity.x = 0
	
func detect_player(detection_range: float = 150.0):
	# Buscar al jugador en el grupo "player"
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		var player = players[0]
		var distance = worm.global_position.distance_to(player.global_position)
		if distance < detection_range:
			return player
	return null	
