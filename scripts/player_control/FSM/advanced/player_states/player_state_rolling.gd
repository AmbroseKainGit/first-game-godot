extends PlayerStateGravityBase

var timer: Timer

func _init():
		# Create a timer for the roll duration
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(_on_roll_finished)
	
func start():
	player.is_rolling = true
	# Set up the attack visuals
	player.change_visibility_roll(true)
	player.play_animation(player.animations.ROLL)
	
	# Start the timer for attack duration
	timer.start(player.movement_stats.basic_roll_duration)
	#player.get_node("Sounds").get_node("AttackSound").playing = true
func _on_roll_finished():
		# Transition to appropriate state when attack finishes
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		state_machine.change_to(player.states.Running)
	else:
		state_machine.change_to(player.states.Idle)

func physics_update(delta: float):
	pass

func on_input(event):
	pass

func end():
	player.is_rolling = false
	timer.stop()
	player.change_visibility_roll(false)
