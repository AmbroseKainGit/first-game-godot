# In PlayerStateGravityBase.gd
class_name PlayerStateGravityBase 
extends PlayerStateBase

var gravity:float = ProjectSettings.get_setting("physics/2d/default_gravity")

func handle_gravity(delta: float):
	player.velocity.y += gravity * delta

# Implement the on_physics_process that your state machine will call
func on_physics_process(delta: float):
	# Apply gravity first
	handle_gravity(delta)
	
	# Do state-specific physics processing
	physics_update(delta)
	
	# Move the character
	player.move_and_slide()

# Child classes can override this instead of on_physics_process
func physics_update(delta: float):
	pass  # To be implemented by child classes
