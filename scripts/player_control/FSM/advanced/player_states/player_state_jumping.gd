extends PlayerStateGravityBase

func physics_update(delta: float): 
	player.play_animation(player.animations.JUMP)
	if player.is_on_floor() and player.velocity.y >=0:
		player.velocity.y = player.movement_stats.JUMP_SPEED
	
	# Horizontal movement
	player.velocity.x = \
	 Input.get_axis("move_left", "move_right") * player.movement_stats.SPEED
	
func on_input(event):
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"): 
		state_machine.change_to(player.states.Running)
	elif not Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"): 
		state_machine.change_to(player.states.Idle)	
