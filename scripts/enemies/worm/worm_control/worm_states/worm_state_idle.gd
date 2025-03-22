extends WormStateGravityBase
var timer = 0.0
var idle_time = 0
var animation_started = false
var vision_range = worm.movement_stats.VISION_RANGE
var attack_range = worm.movement_stats.ATTACK_RANGE

func start():
	super.start()
	worm.change_sprite_visibility("SpriteIdle")
	timer = 0.0
	idle_time = randi_range(2, 6)
	animation_started = false
	# Mantener la misma orientación del sprite
	worm.sprite.flip_h = (worm.facing_direction < 0)
	
func physics_update(delta: float):
	super.physics_update(delta)
	if not animation_started:
		await get_tree().create_timer(0.05).timeout
		worm.play_animation(worm.animations.IDLE)
		animation_started = true
	worm.velocity.x = 0
		# Actualizar el temporizador
	timer += delta

	# Cambiar a estado de patrulla cuando el temporizador alcance el tiempo definido
	var player = worm.detect_player()
	if player and worm.is_in_attack_range(player):		
		state_machine.change_to(worm.states.Attack)
	elif player:
		state_machine.change_to(worm.states.Chase)
	else:
		if timer >= idle_time:
			state_machine.change_to(worm.states.Patrol)

