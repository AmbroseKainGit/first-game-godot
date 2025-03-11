extends PlayerStateGravityBase

var timer: Timer

func _init():
	# Create a timer for the attack duration
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(_on_attack_finished)

func start():
	# Set up the attack visuals
	player.change_visibility_attack(true)
	player.play_animation(player.animations.ATTACK)
	
	# Start the timer for attack duration
	timer.start(player.attack_stats.basic_attack_duration)
	#player.get_node("Sounds").get_node("AttackSound").playing = true

func _on_attack_finished():
	# Transition to appropriate state when attack finishes
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		state_machine.change_to(player.states.Running)
	else:
		state_machine.change_to(player.states.Idle)
	
func physics_update(delta: float): 
	# Ensure player doesn't move during attack
	player.velocity = Vector2.ZERO
	
	# Track attack animation time
	#if not attack_finished:
		#attack_timer += delta
		#if attack_timer >= attack_duration:
			#attack_finished = true
			## Return to appropriate state when attack finishes
			#if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
				#state_machine.change_to(player.states.Running)
			#else:
				#state_machine.change_to(player.states.Idle)

func on_input(event):
	# Ignore input during attack animation
	pass
	
#func on_input(event):
	## Only allow input handling after attack is finished
	#if attack_finished:
		#if Input.is_action_just_pressed("jump") and (player.is_on_floor() or player.coyote_timer > 0):
			#state_machine.change_to(player.states.Jumping)
		#elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"): 
			#state_machine.change_to(player.states.Running)
		#elif Input.is_action_pressed("ui_down"): 
			#state_machine.change_to(player.states.Crouching)
		
func end():
	# Clean up when leaving this state
	timer.stop()
	player.change_visibility_attack(false)	
