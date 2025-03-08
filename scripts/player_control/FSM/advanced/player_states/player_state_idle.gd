extends PlayerStateGravityBase

func physics_update(delta: float): 
	player.play_animation(player.animations.IDLE)
	player.velocity.x = 0
	
func on_input(event):
	if Input.is_action_just_pressed("jump"):
		state_machine.change_to(player.states.Jumping)
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"): 
		state_machine.change_to(player.states.Running)
		
	
