@tool
extends Control
class_name HealthBar

@export var health_stats: CharacterHealthStats
	#set(new_health_stats):
		#health_stats = new_health_stats
		#if health_stats && is_inside_tree():
			#setup_health_connections()
	
@export var bar_color: Color = Color(0.2, 0.8, 0.2) : set = set_bar_color  # Green
@export var background_color: Color = Color(0.2, 0.2, 0.2) : set = set_background_color  # Dark gray
@export var low_health_threshold: float = 0.3  # 30% health is considered low
@export var low_health_color: Color = Color(0.8, 0.2, 0.2) : set = set_low_health_color  # Red
@export var bar_height: int = 5  # Height of the progress bar

@onready var progress_bar: ProgressBar = $ProgressBar

func _ready() -> void:
	# Connect to player when it's ready
	call_deferred("find_and_connect_to_player")

func find_and_connect_to_player() -> void:
	# Find the player in the scene
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_method("get_health_stats"):
		self.health_stats = player.get_health_stats()
		setup_health_connections()

# This function can be called both from _ready and when health_stats is set
func setup_health_connections() -> void:
	print("Setting up health connections")
	
	# Disconnect any existing connections to avoid duplicates
	if health_stats.health_changed.is_connected(_on_health_changed):
		health_stats.health_changed.disconnect(_on_health_changed)
	
	# Connect the signal
	health_stats.health_changed.connect(_on_health_changed)
	print("Connected health_changed signal")
	
	# Update the initial values
	_on_health_changed(health_stats.current_health, health_stats.max_health)

func set_bar_color(color: Color) -> void:
	if is_instance_valid(progress_bar):
		# This assumes you're using a StyleBoxFlat for the progress bar
		var style = progress_bar.get("theme_override_styles/fill")
		if style:
			style.bg_color = color

func set_background_color(color: Color) -> void:
	background_color = color
	if is_instance_valid(progress_bar):
		# This assumes you're using a StyleBoxFlat for the background
		var style = progress_bar.get("theme_override_styles/background")
		if style:
			style.bg_color = color


func set_low_health_color(color: Color) -> void:
	low_health_color = color

func _on_health_changed(new_health: float, max_health: float) -> void:
	print("Health changed: ", new_health, "/", max_health)
	progress_bar.max_value = max_health
	progress_bar.value = new_health
	
	# Change color based on health percentage
	var health_percent = new_health / max_health
	if health_percent <= low_health_threshold:
		set_bar_color(low_health_color)
	else:
		set_bar_color(bar_color)		
