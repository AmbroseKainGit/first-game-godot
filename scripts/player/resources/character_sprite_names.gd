class_name CharacterSpriteNames extends Resource
var animations:PlayerAnimationNames = PlayerAnimationNames.new()

@export var sprite_list : Dictionary = {
	animations.IDLE: "Sprite2D",
	animations.CROUCH: "CrouchedSprite",
	animations.ATTACK: "BasicAttackSprite"
}
