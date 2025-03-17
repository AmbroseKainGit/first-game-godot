class_name WormEnemy
extends CharacterBody2D

@onready var sprite: Sprite2D = $SpriteIdle
@onready var sprite_walk: Sprite2D = $SpriteWalk
@onready var sprite_attack: Sprite2D = $SpriteAttack
@onready var sprite_hit: Sprite2D = $SpriteHit
@onready var sprite_death: Sprite2D = $SpriteDeath
@onready var animation_tree: AnimationTree = $AnimationTree

var health_stats: CharacterHealthStats = CharacterHealthStats.new()
var anim_controller: AnimationController
var movement_stats:WormStatsValues = WormStatsValues.new()
var states:WormStatesNames = WormStatesNames.new()
var animations:WormAnimationNames = WormAnimationNames.new()
# Variable para mantener la dirección en la que mira el enemigo
var facing_direction = 1  # 1 derecha, -1 izquierda

#region Animations Dict
var animation_mapping = {
	animations.IDLE: "parameters/conditions/Idle",
	animations.WALK: "parameters/conditions/Walk",
	animations.ATTACK: "parameters/conditions/Attack"
}
#endregion
#
func _ready():
	# Add the player to a group so the health bar can find it
	add_to_group("enemies")
	# Initialize health system first
	initialize_health()
	call_deferred("initialize_animations")

func initialize_animations():
	# Initialize animation controller with all animations
	anim_controller = AnimationController.new(animation_tree)
	anim_controller.register_animations(animation_mapping)
	add_child(anim_controller)
#
func get_health_stats() -> CharacterHealthStats:
	return health_stats

func initialize_health():
	# Initialize health system with custom values
	health_stats.max_health = 100.0
	health_stats.current_health = 100.0
	health_stats.regeneration_rate = 0.0  # Set to a value > 0 for passive health regen
	health_stats.initialize()
#
func change_sprite_visibility(sprite_name: String) -> void:
 #Lista de todos los sprites disponibles
	var sprites = ["SpriteIdle", "SpriteWalk", "SpriteAttack", "SpriteHit", "SpriteDeath"]
	# Ocultar todos los sprites primero
	for sprite in sprites:
		if has_node(sprite):
			get_node(sprite).visible = false
	# Mostrar solo el sprite solicitado
		if has_node(sprite_name):
			get_node(sprite_name).visible = true
		else:
			push_error("Sprite '" + sprite_name + "' no encontrado")

func _physics_process(delta: float) -> void:
	pass

func play_animation(animation_name: String):
	anim_controller.play(animation_name)

func set_facing_direction(direction: int):
	# Función para voltear todos los sprites según la dirección
	var flip = direction < 0
	sprite.flip_h = flip
	sprite_walk.flip_h = flip
	sprite_attack.flip_h = flip
	sprite_hit.flip_h = flip
	sprite_death.flip_h = flip
	
func check_floor_ahead(direction: int, distance: float = 20.0):
	var can_move = true
	
	# 1. Verificar si hay suelo adelante (raycast vertical)
	var floor_raycast = RayCast2D.new()
	add_child(floor_raycast)
	floor_raycast.position = Vector2(direction * distance, 0)
	floor_raycast.target_position = Vector2(0, 30)
	floor_raycast.enabled = true
	floor_raycast.force_raycast_update()
	
	var has_floor = floor_raycast.is_colliding()
	remove_child(floor_raycast)
	floor_raycast.queue_free()
	
	# 2. Verificar si hay paredes adelante (raycast horizontal)
	var wall_raycast = RayCast2D.new()
	add_child(wall_raycast)
	wall_raycast.position = Vector2(0, 0)  # Centro del personaje
	wall_raycast.target_position = Vector2(direction * distance, 0)
	wall_raycast.enabled = true
	wall_raycast.force_raycast_update()
	
	var has_wall = wall_raycast.is_colliding()
	remove_child(wall_raycast)
	wall_raycast.queue_free()
	
	# Puede moverse si hay suelo Y no hay pared
	return has_floor && !has_wall;
