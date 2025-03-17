class_name AnimationController
extends Node

var animation_tree: AnimationTree
var animation_states = {}

func _init(tree: AnimationTree):
	animation_tree = tree

# Register a dictionary of animations at once
func register_animations(animations_dict: Dictionary):
	animation_states = animations_dict

# Individual registration still available
func register_state(state_name: String, condition_path: String):
	animation_states[state_name] = condition_path
	
func reset_animations(animations_to_reset = null):
	# If no specific animations provided, reset all animations
	if animations_to_reset == null:
		for anim_path in animation_states.values():
			animation_tree[anim_path] = false
	else:
		# Reset only the specified animations
		for anim_name in animations_to_reset:
			if animation_states.has(anim_name):
				animation_tree[animation_states[anim_name]] = false

func play(animation_name: String):
	# Reset all animations first
	reset_animations()
	
	# Set the requested animation condition to true
	if animation_states.has(animation_name):
		animation_tree[animation_states[animation_name]] = true
	else:
		push_warning("Animation not found: " + animation_name)

#func state_idle(active: bool) -> void:
	#animation_tree["parameters/conditions/idle"] = active
	#animation_tree["parameters/conditions/run"] = not active
	#
#func state_jump(active: bool) -> void:
	#animation_tree["parameters/conditions/jump"] = active
	#await get_tree().create_timer(.1).timeout
	#animation_tree["parameters/conditions/jump"] = not active

#func state_run(active: bool) -> void:
	#animation_tree["parameters/conditions/run"] = active
	#animation_tree["parameters/conditions/idle"] = not active		
