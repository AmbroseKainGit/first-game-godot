class_name BaseState extends Node

#Referencia al nodo a controlar
@onready var controlled_node:Node = self.owner

var state_machine:StateMachine

#region Common methods

## Method executed at the start of the state
func start():
	pass
	
func end():
	pass	
#endregion
