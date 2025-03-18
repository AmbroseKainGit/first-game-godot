# animation_types.gd
class_name AnimationTypes
extends Node

enum Type {
	IDLE,
	RUN,
	JUMP,
	FALLING,
	CROUCH,
	ATTACK
}

# Convert animation type to string representation
static func type_to_string(type: Type) -> String:
	match type:
		Type.IDLE: return "idle"
		Type.RUN: return "run"
		Type.JUMP: return "jump"
		Type.FALLING: return "falling"
		Type.CROUCH: return "crouch"
		Type.ATTACK: return "attack"
		_: return "unknown"
