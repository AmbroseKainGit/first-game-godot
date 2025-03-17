extends PlayerStateGravityBase

func start():
	player.change_sprite_visibility(player.animations.IDLE)

func physics_update(delta: float): 
	player.play_animation(player.animations.IDLE)
	player.velocity.x = 0
	if not player.is_on_floor() and player.velocity.y > 0:
		state_machine.change_to(player.states.Falling)
	
func on_input(event):
	if Input.is_action_just_pressed("jump") and (player.is_on_floor() or player.coyote_timer > 0):
		state_machine.change_to(player.states.Jumping)
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"): 
		state_machine.change_to(player.states.Running)
	elif Input.is_action_pressed("ui_down"): 
		state_machine.change_to(player.states.Crouching)
	elif Input.is_action_just_pressed("attack"):
		state_machine.change_to(player.states.Attacking)	
		
	
