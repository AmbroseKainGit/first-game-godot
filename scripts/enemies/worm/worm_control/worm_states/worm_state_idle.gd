extends WormStateGravityBase
var timer = 0.0
var idle_time = 3.0
var animation_started = false

func start():
	super.start()
	worm.change_sprite_visibility("SpriteIdle")
	animation_started = false
	
func physics_update(delta: float):
	super.physics_update(delta)
	if not animation_started:
		worm.play_animation(worm.animations.IDLE)
		animation_started = true
	worm.velocity.x = 0
		# Actualizar el temporizador
	timer += delta

	# Cambiar a estado de patrulla cuando el temporizador alcance el tiempo definido
	if timer >= idle_time:
		state_machine.change_to(worm.states.Patrol)
