# sprite_visibility_manager.gd
class_name SpriteVisibilityManager
extends Resource

# Reference to the sprites container
var sprites_container: Node

# Dictionary mapping animation types to sprite node names
@export var sprite_map: Dictionary = {}

# Initialize with parent node
func _init(p_sprite_map: Dictionary = {}, p_sprites_container: Node = null) -> void:
	sprite_map = p_sprite_map
	sprites_container = p_sprites_container

# Change which sprite is visible based on animation type
func change_sprite_visibility(sprite_name: String) -> void:
	if sprites_container == null:
		push_error("Sprites container not found in SpriteVisibilityManager")
		return	
		
	# Hide all sprites first
	for sprite_key in sprite_map:
		var node_name = sprite_map[sprite_key]
		if sprites_container.has_node(node_name):
			sprites_container.get_node(node_name).visible = false
	
	# Show only the requested sprite
	if sprite_map.has(sprite_name):
		var requested_node = sprite_map[sprite_name]
		prints("requested_node", requested_node)
		if sprites_container.has_node(requested_node):
			sprites_container.get_node(requested_node).visible = true
		else:
			push_error("Sprite node '" + requested_node + "' not found in " + sprites_container.name)
	else:
		push_error("Sprite key '" + sprite_name + "' not found in sprite_list")
