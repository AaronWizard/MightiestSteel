class_name State
extends Node

signal request_state_change(state_name: String, data: Dictionary)

var allow_input := true


func start(_data: Dictionary) -> void:
	pass


func end() -> void:
	pass


func handle_unhandled_input(_event: InputEvent) -> void:
	pass
