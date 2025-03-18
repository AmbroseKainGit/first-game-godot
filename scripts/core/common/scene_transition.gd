extends CanvasLayer

signal transition_started
signal transition_finished


var next_scene: String = ""
var is_transitioning: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# Make sure we're not visible initially
	$ColorRect.color.a = 0
	$ColorRect/LoadingLabel.modulate.a = 0
	# Make sure input passing is enabled
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_IGNORE

# Function to start transition and provide the next scene to load
func transition_to(scene_path: String):
	# Set transitioning flag to block input
	is_transitioning = true
	
	# Make ColorRect block mouse input during transition
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_STOP
	
	# Emit signal that we're starting a transition
	emit_signal("transition_started")
	
	# Store the next scene and start transition
	next_scene = scene_path
	$AnimationPlayer.play("transition")

# This is called when the transition animation finishes
func _on_animation_player_animation_finished(anim_name: String):
	if anim_name == "transition":
		# Reset transitioning flag and allow mouse input again
		is_transitioning = false
		$ColorRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		# Emit signal that transition is finished
		emit_signal("transition_finished")

# Called by the animation player during the transition animation
func change_scene():
	# Actually change to the new scene
	get_tree().change_scene_to_file(next_scene)
	_on_animation_player_animation_finished("transition")

# This function can be called from other scripts to check if a transition is in progress
func is_transition_active():
	return is_transitioning
