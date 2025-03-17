extends WormStateGravityBase
var timer = 0.0
var idle_time = 0
var animation_started = false

func start():
	super.start()
	timer = 0.0
	worm.change_sprite_visibility("SpriteIdle")
	idle_time = randi_range(2, 6)
	animation_started = false
	# Mantener la misma orientación del sprite
	worm.sprite.flip_h = (worm.facing_direction < 0)
	
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
