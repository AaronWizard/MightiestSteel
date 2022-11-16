class_name PlayerState
extends ActorControlState


func start(_data: Dictionary) -> void:
	print("player started")


func handle_unhandled_input(_event: InputEvent) -> void:
	pass
