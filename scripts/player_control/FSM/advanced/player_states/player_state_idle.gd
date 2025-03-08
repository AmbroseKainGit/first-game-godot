extends BaseState

var gravity:float = ProjectSettings.get_setting("physics/2d/default_gravity")

func on_physics_process(delta: float): 
	controlled_node.play_animation("idle")
	controlled_node.velocity.x = 0
	handle_gravity(delta)
	controlled_node.move_and_slide()
	
func handle_gravity(delta: float):
	controlled_node.velocity.y += gravity * delta
	
func on_input(event):
	if Input.is_action_pressed("move_left")	or Input.is_action_pressed("move_right"): 
		state_machine.change_to("PlayerStateRunning")
	
