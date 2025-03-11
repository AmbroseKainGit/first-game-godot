extends PlayerStateGravityBase

func start():
	if player.velocity.y > 0:  # If falling without jumping
		player.coyote_timer = player.coyote_time
		
		
func physics_update(delta: float): 
	player.play_animation(player.animations.FALLING)
	
	 # Allow jumping during coyote time - only if we didn't already jump
	if Input.is_action_just_pressed("jump") and player.coyote_timer > 0 and not player.has_jumped:
		player.velocity.y = player.movement_stats.JUMP_SPEED
		player.has_jumped = true  # Set the flag to prevent further jumps
		state_machine.change_to(player.states.Jumping)
		return
		
	# Update coyote timer	
	if player.coyote_timer > 0:
		player.coyote_timer -= delta
		
	# Horizontal movement
	player.velocity.x = \
	 Input.get_axis("move_left", "move_right") * player.movement_stats.SPEED
	
	if player.velocity.y >= 0 and player.is_on_floor():
		# Check if movement keys are being held when landing
		if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
			state_machine.change_to(player.states.Running)
		else:
			state_machine.change_to(player.states.Idle)
