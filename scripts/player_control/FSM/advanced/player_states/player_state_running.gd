extends PlayerStateGravityBase

const SPEED = 100.0

func physics_update(delta: float): 
	player.change_visibility_crouch(false)
	player.play_animation(player.animations.RUN)
	player.velocity.x = Input.get_axis("move_left", "move_right") * player.movement_stats.SPEED
	if not player.is_on_floor() and player.velocity.y > 0:
		state_machine.change_to(player.states.Falling)
	
func on_input(event):
	if Input.is_action_just_pressed("jump") and (player.is_on_floor() or player.coyote_timer > 0):
		prints("COYOTE:",player.coyote_timer)
		state_machine.change_to(player.states.Jumping)		
	elif not Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"): 
		state_machine.change_to(player.states.Idle)
	elif Input.is_action_pressed("ui_down"): 
		state_machine.change_to(player.states.Crouching)
	elif Input.is_action_just_pressed("attack"):
		state_machine.change_to(player.states.Attacking)	
