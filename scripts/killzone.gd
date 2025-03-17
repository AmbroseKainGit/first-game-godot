extends Area2D

const Y_LIMIT = 0

@onready var timer: Timer = $Timer
var anim_controller: AnimationController

func _on_body_entered(body: Node2D) -> void:
	print(body.has_method("is_rolling"))
	if position.y > Y_LIMIT:
		print("You died! (Fell off the map)")
		Engine.time_scale = 0.5
		get_tree().create_timer(1.0).timeout
		Engine.time_scale = 1.0
		get_tree().reload_current_scene()
		return
	# validate if body is a instance of Player
	if body is Player and body.animation_tree:
		# access to the condition of the animation roll in the AnimationTree
		var roll_condition_path = body.animation_mapping.get(body.animations.ROLL, "")
		if roll_condition_path and body.animation_tree.get(roll_condition_path):
			print("Evaded the kill zone with roll!")
			return

	print("You died!")
	Engine.time_scale = 0.5
	body.get_node("CollisionShape2D").queue_free()
	timer.start()


func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
