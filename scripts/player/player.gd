class_name Player
extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var crouched_sprite: Sprite2D = $CrouchedSprite
@onready var basic_attack_sprite: Sprite2D = $BasicAttackSprite
@onready var roll_sprite: Sprite2D = $RollSprite

var coyote_time = 0.2
var coyote_timer = 0.0
var was_on_floor = false
var has_jumped = false  # Add this new variable
var locked_direction: float = 1.0  # Guarda la última dirección antes de rodar
var is_rolling: bool = false       # Indica si el personaje está rodando

var health_stats: CharacterHealthStats = CharacterHealthStats.new()
var anim_controller: AnimationController
var movement_stats:CharacterMovementStats = CharacterMovementStats.new()
var attack_stats:CharacterAttacktStats = CharacterAttacktStats.new()
var states:PlayerStatesNames = PlayerStatesNames.new()
var animations:PlayerAnimationNames = PlayerAnimationNames.new()

#region Animations Dict
var animation_mapping = {
	animations.IDLE: "parameters/conditions/idle",
	animations.RUN: "parameters/conditions/run",
	animations.JUMP: "parameters/conditions/jump",
	animations.FALLING: "parameters/conditions/falling",
	animations.CROUCH: "parameters/conditions/crouch",
	animations.ATTACK: "parameters/conditions/attack",
	animations.ROLL: "parameters/conditions/roll"
}
#endregion

func _ready():
	# Add the player to a group so the health bar can find it
	add_to_group("player")
	
	# Initialize health system first
	initialize_health()
	
	call_deferred("initialize_animations")
	
func change_visibility_roll(state: bool):
	# Toggle visibility
	roll_sprite.visible = state
	sprite.visible = !state
	basic_attack_sprite.visible = false
	crouched_sprite.visible = false

func change_visibility_crouch(state: bool):
	# Toggle visibility
	crouched_sprite.visible = state
	sprite.visible = !state
	basic_attack_sprite.visible = false
	
func change_visibility_attack(state: bool):
	# Toggle visibility
	basic_attack_sprite.visible = state	
	crouched_sprite.visible = false
	sprite.visible = !state
	
func initialize_animations():
	# Initialize animation controller with all animations
	anim_controller = AnimationController.new(animation_tree)
	anim_controller.register_animations(animation_mapping)
	add_child(anim_controller)

func get_health_stats() -> CharacterHealthStats:
	return health_stats

func initialize_health():
	# Initialize health system with custom values
	health_stats.max_health = 100.0
	health_stats.current_health = 100.0
	health_stats.regeneration_rate = 0.0  # Set to a value > 0 for passive health regen
	health_stats.initialize()

func set_facting_direction(x:float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	# If rolling, direction is locked
	if is_rolling:
		sprite.scale.x = locked_direction
		crouched_sprite.scale.x = locked_direction
		basic_attack_sprite.scale.x = locked_direction
		roll_sprite.scale.x = locked_direction
	elif direction != 0:
		locked_direction = sign(direction)  # Store direction when isn't rolling
		sprite.scale.x = locked_direction
		crouched_sprite.scale.x = locked_direction
		basic_attack_sprite.scale.x = locked_direction
		roll_sprite.scale.x = locked_direction

func update_coyote_time(delta: float) ->void:
	# Update was_on_floor at the beginning of physics processing
	if is_on_floor():
		was_on_floor = true
		coyote_timer = coyote_time
		has_jumped = false  # Reset jump flag when on floor
	else:
		if was_on_floor and not has_jumped:  # Only allow coyote time if player didn't jump
			# Just left the ground without jumping
			coyote_timer -= delta
			if coyote_timer <= 0:
				was_on_floor = false
				coyote_timer = 0
		else:
			# Player jumped or coyote time expired
			coyote_timer = 0

func _physics_process(delta: float) -> void:
	set_facting_direction(velocity.x)
	update_coyote_time(delta)
	
func play_animation(animation_name: String):
	anim_controller.play(animation_name)
	
func _input(event):
	# Test damage with H key
	if event is InputEventKey and event.keycode == KEY_H and event.pressed and not event.echo:
		print("Taking damage")
		health_stats.take_damage(10.0)
	
	# Test healing with J key
	if event is InputEventKey and event.keycode == KEY_J and event.pressed and not event.echo:
		print("Healing")
		health_stats.heal(10.0)	
