class_name StateMachine extends Node

## Node that we are going to controll
@onready var controlled_node = self.owner

## Base state
@export var default_state:BaseState

## Current executed state
var current_state:BaseState = null

func _ready() -> void:
	call_deferred("_state_default_start")

func _state_default_start () -> void: 
	if default_state:
		current_state = default_state
		_state_start()
	else:
		prints("No default state assigned to the StateMachine")	

## Function that prepare the variables for the new state and run their start method
func _state_start() ->void :
	if controlled_node.name != 'Player':
		prints("StateMachine", controlled_node.name, "start state", current_state.name)
	current_state.controlled_node = controlled_node
	current_state.state_machine = self
	current_state.start()
			
## Function to change to a new state
func change_to(new_state:String) ->void:
	if current_state and current_state.has_method("end"):current_state.end()
	current_state = get_node(new_state)
	_state_start()
	

#region Autoexecuted methods

func _process(delta: float) -> void:
	if current_state and current_state.has_method("on_process"):
		current_state.on_process(delta)
	
func _physics_process(delta: float) -> void:
	if current_state and current_state.has_method("on_physics_process"):
		current_state.on_physics_process(delta)
		
func _input(event: InputEvent) -> void:
	if current_state and current_state.has_method("on_input"):
		current_state.on_input(event)
		
func _unhandled_input(event: InputEvent) -> void:
	if current_state and current_state.has_method("on_unhandled_input"):
		current_state.on_unhandled_input(event)
		
func _unhandled_key_input(event: InputEvent) -> void:
	if current_state and current_state.has_method("on_unhandled_key_input"):
		current_state.on_unhandled_input(event)			

#endregion
