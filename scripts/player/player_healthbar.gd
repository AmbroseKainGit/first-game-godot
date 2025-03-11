#@tool
#extends Control
#class_name HealthBar
#
##region Variables for stats and color
#@export var health_stats: CharacterHealthStats
#@export var bar_color: Color = Color(0.2, 0.8, 0.2) : set = set_bar_color  # Green
#@export var background_color: Color = Color(0.2, 0.2, 0.2) : set = set_background_color  # Dark gray
#@export var low_health_threshold: float = 0.3  # 30% health is considered low
#@export var low_health_color: Color = Color(0.8, 0.2, 0.2) : set = set_low_health_color  # Red
##endregion 
#@onready var progress_bar: ProgressBar = $ProgressBar
#
#func _ready() -> void:
	#if !Engine.is_editor_hint():
		#if health_stats:
			#health_stats.health_changed.connect(_on_health_changed)
			#_on_health_changed(health_stats.current_health, health_stats.max_health)
		#
		## Set initial colors
		#set_bar_color(bar_color)
		#set_background_color(background_color)
#
#func set_bar_color(color: Color) -> void:
	#bar_color = color
	#if is_instance_valid(progress_bar):
		## This assumes you're using a StyleBoxFlat for the progress bar
		#var style = progress_bar.get("theme_override_styles/fill")
		#if style:
			#style.bg_color = color
#
#func set_background_color(color: Color) -> void:
	#background_color = color
	#if is_instance_valid(progress_bar):
		## This assumes you're using a StyleBoxFlat for the background
		#var style = progress_bar.get("theme_override_styles/background")
		#if style:
			#style.bg_color = color
#
#func set_low_health_color(color: Color) -> void:
	#low_health_color = color
#
#func _on_health_changed(new_health: float, max_health: float) -> void:
	#progress_bar.max_value = max_health
	#progress_bar.value = new_health
	#
	## Change color based on health percentage
	#var health_percent = new_health / max_health
	#if health_percent <= low_health_threshold:
		#set_bar_color(low_health_color)
	#else:
		#set_bar_color(bar_color)			
@tool
extends Control
class_name HealthBar

#@export var health_stats: CharacterHealthStats:
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
	# Make sure the styles are created and applied
	setup_progress_bar_styles()
	#if !Engine.is_editor_hint():
		#if health_stats:
			#health_stats.health_changed.connect(_on_health_changed)
			#_on_health_changed(health_stats.current_health, health_stats.max_health)
			

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

# Create and apply the styles to the progress bar
func setup_progress_bar_styles() -> void:
	if progress_bar:
		# Create fill style (the colored part of the bar)
		var fill_style = StyleBoxFlat.new()
		fill_style.bg_color = bar_color
		fill_style.corner_radius_top_left = 2
		fill_style.corner_radius_top_right = 2
		fill_style.corner_radius_bottom_left = 2
		fill_style.corner_radius_bottom_right = 2
		
		# Create background style
		var bg_style = StyleBoxFlat.new()
		bg_style.bg_color = background_color
		bg_style.corner_radius_top_left = 2
		bg_style.corner_radius_top_right = 2
		bg_style.corner_radius_bottom_left = 2
		bg_style.corner_radius_bottom_right = 2
		
		# Apply the styles
		progress_bar.add_theme_stylebox_override("fill", fill_style)
		progress_bar.add_theme_stylebox_override("background", bg_style)
		
		# Set the ProgressBar properties
		progress_bar.min_value = 0
		progress_bar.max_value = 100
		progress_bar.value = 100
		progress_bar.show_percentage = false  # Hide percentage text
		
		# Set the size of the progress bar
		progress_bar.custom_minimum_size.y = bar_height

func set_bar_color(color: Color) -> void:
	bar_color = color
	if is_instance_valid(progress_bar):
		var style = progress_bar.get_theme_stylebox("fill")
		if style is StyleBoxFlat:
			style.bg_color = color

func set_background_color(color: Color) -> void:
	background_color = color
	if is_instance_valid(progress_bar):
		var style = progress_bar.get_theme_stylebox("background")
		if style is StyleBoxFlat:
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
