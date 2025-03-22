class_name WormEnemy
extends CharacterBody2D

@onready var sprite: Sprite2D = $SpriteIdle
@onready var sprite_walk: Sprite2D = $SpriteWalk
@onready var sprite_attack: Sprite2D = $SpriteAttack
@onready var sprite_hit: Sprite2D = $SpriteHit
@onready var sprite_death: Sprite2D = $SpriteDeath
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var vision_range: Area2D = $Direction/VisionRange
@onready var directionNode: Node2D = $Direction
@onready var floor_check_left: RayCast2D
@onready var floor_check_right: RayCast2D
@onready var wall_check_left: RayCast2D
@onready var wall_check_right: RayCast2D

var health_stats: CharacterHealthStats = CharacterHealthStats.new()
var anim_controller: AnimationController
var movement_stats:WormStatsValues = WormStatsValues.new()
var states:WormStatesNames = WormStatesNames.new()
var animations:WormAnimationNames = WormAnimationNames.new()
# Variable para mantener la dirección en la que mira el enemigo
var facing_direction = 1  # 1 derecha, -1 izquierda
# Variables para la detección del jugador
var player_in_sight = false
var player_detected = null
var proximity_detection_active = false
var proximity_timer = 0.0

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
	vision_range.connect("body_entered", Callable(self, "_on_vision_cone_body_entered"))
	vision_range.connect("body_exited", Callable(self, "_on_vision_cone_body_exited"))
	setup_raycasts()

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
	# Lista de todos los sprites disponibles
	var sprites = ["SpriteIdle", "SpriteWalk", "SpriteAttack", "SpriteHit", "SpriteDeath"]
	
	# Ocultar todos los sprites primero
	for sprite_node in sprites:
		if has_node(sprite_node):
			get_node(sprite_node).visible = false
	
	# Mostrar solo el sprite solicitado (FUERA del bucle)
	if has_node(sprite_name):
		get_node(sprite_name).visible = true
	else:
		push_error("Sprite '" + sprite_name + "' no encontrado")

func _physics_process(delta: float) -> void:
	# Verificar detección por proximidad
	if proximity_detection_active and player_detected:
		# Verificar si el jugador sigue cerca
		var distance = global_position.distance_to(player_detected.global_position)
		
		if distance > movement_stats.PROXYMITY_RANGE:
			# Si el jugador se alejó, perder detección
			proximity_detection_active = false
			player_in_sight = false
			player_detected = null
		elif player_in_sight == false:
			# Verificar si el jugador volvió a entrar en el cono
			# (esto lo manejaría la señal body_entered)
			pass

func play_animation(animation_name: String):
	anim_controller.play(animation_name)

func set_facing_direction(direction: int):
	facing_direction = direction  # Guardar la dirección actual
	var flip = direction < 0
	
	# Voltear sprites
	sprite.flip_h = flip
	sprite_walk.flip_h = flip
	sprite_attack.flip_h = flip
	sprite_hit.flip_h = flip
	sprite_death.flip_h = flip
	
	# Girar el nodo Direction
	if has_node("Direction"):
		directionNode.scale.x = -1 if flip else 1
		
func setup_raycasts():
	# Raycasts para verificar el suelo
	floor_check_left = RayCast2D.new()
	floor_check_left.collision_mask = 1
	floor_check_left.position = Vector2(-20, 0)  # 20 píxeles a la izquierda
	floor_check_left.target_position = Vector2(0, 30)
	floor_check_left.enabled = true
	add_child(floor_check_left)
	
	floor_check_right = RayCast2D.new()
	floor_check_right.collision_mask = 1
	floor_check_right.position = Vector2(20, 0)  # 20 píxeles a la derecha
	floor_check_right.target_position = Vector2(0, 30)
	floor_check_right.enabled = true
	add_child(floor_check_right)
	
	# Raycasts para verificar paredes
	wall_check_left = RayCast2D.new()
	wall_check_left.collision_mask = 1
	wall_check_left.position = Vector2(0, 0)
	wall_check_left.target_position = Vector2(-20, 0)  # 20 píxeles a la izquierda
	wall_check_left.enabled = true
	add_child(wall_check_left)
	
	wall_check_right = RayCast2D.new()
	wall_check_right.collision_mask = 1
	wall_check_right.position = Vector2(0, 0)
	wall_check_right.target_position = Vector2(20, 0)  # 20 píxeles a la derecha
	wall_check_right.enabled = true
	add_child(wall_check_right)

# Nueva función de verificación completa
func check_floor_ahead(direction: int, distance: float = 20.0):
	var has_floor = false
	var has_wall = false
	
	if direction > 0:
		has_floor = floor_check_right.is_colliding()
		has_wall = wall_check_right.is_colliding()
	else:
		has_floor = floor_check_left.is_colliding()
		has_wall = wall_check_left.is_colliding()
	
	# Solo se puede mover si hay suelo y no hay pared
	return has_floor && !has_wall
		
func _on_vision_cone_body_entered(body):
	print("Body entered: ", body.name)
	if body.is_in_group("player"):
		print("PLayer dteca")
		player_in_sight = true
		player_detected = body
	
func _on_vision_cone_body_exited(body):
	print("Body exit: ", body.name)	
	if body.is_in_group("player") and body == player_detected:
	# En lugar de perder inmediatamente al jugador, verificar proximidad
		var distance = global_position.distance_to(body.global_position)
		if distance < movement_stats.PROXYMITY_RANGE:
			# Si está cerca, mantener la detección pero activar timer
			proximity_detection_active = true
		else:
			# Si está lejos, perder detección inmediatamente
			player_in_sight = false
			player_detected = null

func detect_player():
	return player_detected
	
func is_in_attack_range(player = null):
	if player == null:
		player = player_detected
	
	if player:
		var distance = global_position.distance_to(player.global_position)
		return distance < movement_stats.ATTACK_RANGE
	return false
