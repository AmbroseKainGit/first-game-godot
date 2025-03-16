class_name WormStateBase extends BaseState

var worm:WormEnemy:
	set (value):
		controlled_node = value
	get:
		return controlled_node
