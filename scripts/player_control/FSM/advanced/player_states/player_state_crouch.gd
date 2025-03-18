extends PlayerStateGravityBase

func start():
	player.change_sprite_visibility(player.animations.CROUCH)

func physics_update(delta: float): 
	# Horizontal movement
	player.velocity = Vector2.ZERO

func on_input(event):
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		state_machine.change_to(player.states.Running)
	if Input.is_action_just_released("ui_down"):
		state_machine.change_to(player.states.Idle)
	elif Input.is_action_just_pressed("attack"):
		state_machine.change_to(player.states.Attacking)	
