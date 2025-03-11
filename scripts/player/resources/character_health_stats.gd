# character_health_stats.gd
class_name CharacterHealthStats
extends Resource

signal health_changed(new_health: float, max_health: float)
signal health_depleted

@export var max_health: float = 100.0
@export var current_health: float = 100.0
@export var regeneration_rate: float = 0.0  # Health regen per second, 0 means no regen
@export var armor: float = 0.0  # Damage reduction percentage (0-1)
@export var is_invulnerable: bool = false

func initialize(starting_health: float = max_health):
	current_health = min(starting_health, max_health)
	print("Initializing health to: ", current_health, "/", max_health)
	emit_signal("health_changed", current_health, max_health)

func take_damage(amount: float) -> float:
	if is_invulnerable:
		return 0.0
		
	var actual_damage = amount * (1.0 - armor)
	current_health = max(0, current_health - actual_damage)
	emit_signal("health_changed", current_health, max_health)
	
	if current_health <= 0:
		emit_signal("health_depleted")
		
	return actual_damage

func heal(amount: float) -> float:
	var health_before = current_health
	current_health = min(max_health, current_health + amount)
	emit_signal("health_changed", current_health, max_health)
	
	return current_health - health_before  # Return actual amount healed

func regenerate(delta: float) -> void:
	if regeneration_rate > 0 and current_health < max_health:
		heal(regeneration_rate * delta)

func get_health_percent() -> float:
	return current_health / max_health

func set_max_health(new_max: float, update_current: bool = false) -> void:
	max_health = max(1.0, new_max)
	
	if update_current:
		current_health = max_health
	else:
		# Ensure current health doesn't exceed the new maximum
		current_health = min(current_health, max_health)
		
	emit_signal("health_changed", current_health, max_health)
