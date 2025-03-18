extends Node

func _ready():
	call_deferred("on_ready")

func on_ready():
	prints("ON READY")
	# Access SceneTransition via SceneTree instead of Engine
	if get_node_or_null("/root/SceneTransition") != null:
		prints("FOUND SCENE TRANSITION")
		var transition = get_node("/root/SceneTransition")
		# Connect to signals
		transition.connect("transition_started", _on_transition_started)
		transition.connect("transition_finished", _on_transition_finished)

func _on_transition_started():
	prints("TRANSITION STARTED - PAUSING GAME")
	# Pause the game when transition starts
	get_tree().paused = true

func _on_transition_finished():
	prints("TRANSITION FINISHED - RESUMING GAME")
	# Resume the game when transition ends
	#var transition = get_node("/root/SceneTransition")
	#get_tree().change_scene_to_file(transition.next_scene)
	await get_tree().create_timer(.5).timeout
	get_tree().paused = false
