class_name Player
extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var player_sprites: Node = $PlayerSprites


var coyote_time = 0.2
var coyote_timer = 0.0
var was_on_floor = false
var has_jumped = false  # Add this new variable

var health_stats: CharacterHealthStats = CharacterHealthStats.new()
var anim_controller: AnimationController
var movement_stats:CharacterMovementStats = CharacterMovementStats.new()
var attack_stats:CharacterAttacktStats = CharacterAttacktStats.new()
var states:PlayerStatesNames = PlayerStatesNames.new()
var animations:PlayerAnimationNames = PlayerAnimationNames.new()
var sprites:CharacterSpriteNames = CharacterSpriteNames.new()
var sprite_manager: SpriteVisibilityManager

#region Animations Dict
var animation_mapping = {
	animations.IDLE: "parameters/conditions/idle",
	animations.RUN: "parameters/conditions/run",
	animations.JUMP: "parameters/conditions/jump",
	animations.FALLING: "parameters/conditions/falling",
	animations.CROUCH: "parameters/conditions/crouch",
	animations.ATTACK: "parameters/conditions/attack"
}
#endregion

func _ready():
	# Add the player to a group so the health bar can find it
	add_to_group("player")
	
	# Initialize health system first
	initialize_health()
	
	call_deferred("initialize_animations")
	sprite_manager = SpriteVisibilityManager.new(sprites.sprite_list, player_sprites)

func change_sprite_visibility(sprite_name: String) -> void:
	sprite_manager.change_sprite_visibility(sprite_name)
	
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
	
	if direction == 0:
		return  # No direction input, no need to change scaling
	
	var scale_x = 1 if direction > 0 else -1
	
	 # Apply scale to all Sprite2D nodes in the PlayerSprites hierarchy
	_set_sprite_scale_recursive(player_sprites, scale_x)

func _set_sprite_scale_recursive(node: Node, scale_x: float) -> void:
	if node is Sprite2D:
		node.scale.x = scale_x
	
	for child in node.get_children():
		_set_sprite_scale_recursive(child, scale_x)

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
