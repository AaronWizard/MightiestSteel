class_name StateMachine
extends Node

@export var initial_state: NodePath

@onready var _current_state: State = get_node(initial_state)


func _ready() -> void:
	for s in get_children():
		var state := s as State
		@warning_ignore(return_value_discarded)
		state.request_state_change.connect(self.change_state)
	_current_state.start({})


func _unhandled_input(event: InputEvent) -> void:
	if _current_state.allow_input:
		_current_state.handle_unhandled_input(event)


func change_state(state_name: String, data := {}) -> void:
	if has_node(state_name):
		_current_state.end()
		_current_state = get_node(state_name)
		_current_state.start(data)
	else:
		push_warning("State machine '%s' has no state with name '%s'"
				% [name, state_name])
