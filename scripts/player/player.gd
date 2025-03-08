class_name Player
extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree

#region Animations Dict
var animation_mapping = {
	"idle": "parameters/conditions/idle",
	"run": "parameters/conditions/run",
	"jump": "parameters/conditions/jump"
}
#endregion

var anim_controller: AnimationController
var movement_stats:CharacterMovementStats = CharacterMovementStats.new()
var states:PlayerStatesNames = PlayerStatesNames.new()
var animations:PlayerAnimationNames = PlayerAnimationNames.new()

func _ready():
	call_deferred("initialize_animations")

	
func initialize_animations():
	# Initialize animation controller with all animations
	anim_controller = AnimationController.new(animation_tree)
	anim_controller.register_animations(animation_mapping)
	add_child(anim_controller)

func set_facting_direction(x:float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if direction > 0:
		sprite.scale.x = 1
	elif direction < 0:
		sprite.scale.x = -1

func _process(delta: float) -> void:
	set_facting_direction(velocity.x)
	
func play_animation(animation_name: String):
	anim_controller.play(animation_name)

#func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("move_left", "move_right")
	#
	##flip the sprite
	#if direction > 0:
		#animated_sprite.flip_h = false
	#elif direction < 0:
		#animated_sprite.flip_h = true	
	#
	##play animations
	#if is_on_floor():
		#if direction == 0:
			#animated_sprite.play("idle")
		#else:
			#animated_sprite.play("run")	
	#else: 
		#animated_sprite.play("jump")		
	#
	##Apply movement
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()
