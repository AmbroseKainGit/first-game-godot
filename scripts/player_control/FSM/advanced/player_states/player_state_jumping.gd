extends PlayerStateGravityBase

func start():
	player.has_jumped = true

func physics_update(delta: float): 
	player.play_animation(player.animations.JUMP)
	# Horizontal movement
	player.velocity.x = \
	 Input.get_axis("move_left", "move_right") * player.movement_stats.SPEED
	
	if player.is_on_floor() and player.velocity.y >=0:
		player.velocity.y = player.movement_stats.JUMP_SPEED

	if not player.is_on_floor() and player.velocity.y > 0:
		state_machine.change_to(player.states.Falling)
