extends PlayerStateGravityBase

func physics_update(delta: float): 
	player.play_animation(player.animations.FALLING)
	# Horizontal movement
	player.velocity.x = \
	 Input.get_axis("move_left", "move_right") * player.movement_stats.SPEED
	if player.velocity.y >= 0 and player.is_on_floor():
		# Check if movement keys are being held when landing
		if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			state_machine.change_to(player.states.Running)
		else:
			state_machine.change_to(player.states.Idle)
