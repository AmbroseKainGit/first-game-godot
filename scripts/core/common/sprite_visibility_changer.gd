# sprite_visibility_manager.gd
class_name SpriteVisibilityManager
extends Resource

# Reference to the parent node that owns the sprites
var parent_node: Node

# Dictionary mapping animation types to sprite node names
@export var sprite_map: Dictionary = {}

# Initialize with parent node
func _init(p_parent: Node = null, p_sprite_map: Dictionary = {}) -> void:
	parent_node = p_parent
	sprite_map = p_sprite_map

# Change which sprite is visible based on animation type
func change_sprite_visibility(sprite_name: String) -> void:
	if parent_node == null:
		push_error("Parent node not set in SpriteVisibilityManager")
		return
		
	# Hide all sprites first
	for sprite_key in sprite_map:
		var node_name = sprite_map[sprite_key]
		if parent_node.has_node(node_name):
			parent_node.get_node(node_name).visible = false
	
	# Show only the requested sprite
	if sprite_map.has(sprite_name):
		var requested_node = sprite_map[sprite_name]
		prints("requested_node", requested_node)
		if parent_node.has_node(requested_node):
			parent_node.get_node(requested_node).visible = true
		else:
			push_error("Sprite node '" + requested_node + "' not found in " + parent_node.name)
	else:
		push_error("Sprite key '" + sprite_name + "' not found in sprite_list")
