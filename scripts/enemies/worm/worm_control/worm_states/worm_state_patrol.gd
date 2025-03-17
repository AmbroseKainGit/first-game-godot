extends WormStateGravityBase

var patrol_speed = worm.movement_stats.PATROL_SPEED
var direction = 0  # 1 para derecha, -1 para izquierda
var timer = 0.0
var vision_range = worm.movement_stats.VISION_RANGE
var attack_range = worm.movement_stats.ATTACK_RANGE
var animation_started = false
var patrol_time = 0

func start():
	super.start()
	worm.change_sprite_visibility("SpriteWalk")
	timer = 0.0  # Reiniciar temporizador
	patrol_time = randi_range(2, 5)
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
	if player and is_in_attack_range(player):		
		state_machine.change_to(worm.states.Attack)
	elif player:
		state_machine.change_to(worm.states.Chase)
	else:
		patrol(delta)		
	# Cambiar a estado de patrulla cuando el temporizador alcance el tiempo definido
	
	if timer >= patrol_time:
		state_machine.change_to(worm.states.Idle)
	
func patrol(delta):
	# Actualizar temporizador	
	timer += delta
	
	# Comprobar si hay suelo adelante
	if not worm.check_floor_ahead(direction):
		change_direction()
	
	# Mover al enemigo
	worm.velocity.x = direction * patrol_speed
	
func detect_player():
	# Buscar al jugador en el grupo "player"
	var players = worm.get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		var player = players[0]
		var distance = worm.global_position.distance_to(player.global_position)
		if distance < vision_range:
			return player
	return null

func change_direction():
	direction *= -1  # Invertir dirección
	patrol_time = randi_range(1, 5)
	worm.facing_direction = direction
	worm.sprite_walk.flip_h = (direction < 0)  # Voltear sprite según dirección
	
func is_in_attack_range(player):
	var distance = worm.global_position.distance_to(player.global_position)
	return distance < attack_range	
