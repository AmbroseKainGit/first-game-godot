extends PlayerStateGravityBase

const SPEED = 100.0

func physics_update(delta: float): 
	player.play_animation(player.animations.RUN)
	player.velocity.x = Input.get_axis("move_left", "move_right") * player.movement_stats.SPEED
	
func on_input(event):
	if Input.is_action_just_pressed("jump"):
		state_machine.change_to(player.states.Jumping)		
	elif not Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"): 
		state_machine.change_to(player.states.Idle)
	
