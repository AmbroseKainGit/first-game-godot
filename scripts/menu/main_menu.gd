extends Control

func _ready():
	# Optionally play menu music or setup animations here
	pass

func _on_start_button_pressed():
	#Use the global Autoload for scene_transition scene 
	SceneTransition.transition_to("res://scenes/game.tscn")

func _on_exit_button_pressed():
	# Exit the game
	get_tree().quit()
