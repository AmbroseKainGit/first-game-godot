extends BaseState

var gravity:float = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction := Input.get_axis("move_left", "move_right")
const SPEED = 100.0

func on_physics_process(delta: float): 
	controlled_node.play_animation("run")
	if direction:
		controlled_node.velocity.x = direction * SPEED
	else:
		controlled_node.velocity.x = move_toward(controlled_node.velocity.x, 0, SPEED)
	handle_gravity(delta)
	controlled_node.move_and_slide()
	
func handle_gravity(delta: float):
	controlled_node.velocity.y = gravity * delta
	
func on_input(event):
	if not Input.is_action_pressed("move_left")	and not Input.is_action_pressed("move_right"): 
		state_machine.change_to("PlayerSateteIdle")
	
