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
	var player = detect_player()
	if player:
		# Determinar dirección hacia el jugador
		var direction = 1 if player.global_position.x > worm.global_position.x else -1
		worm.set_facing_direction(direction)
		
func end():
	# Resetear manualmente las condiciones de animación cuando salimos del estado
	worm.animation_tree.set("parameters/conditions/Attack", false)
	
	# Asegurarse de que animation_started está resetado para el siguiente estado
	animation_started = false
	
	# Llamar al método de la clase base
	super.end()

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
		animation_started = false
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
