extends Node

signal timeout

@export_range(0, 1, 1, "or_greater") var index_range := 5


var index: int:
	get:
		return _index


var toggle: bool:
	get:
		return _toggle


@onready var _index := 0
@onready var _toggle := true


func _on_timer_timeout() -> void:
	_index = (_index + 1) % index_range
	_toggle = not _toggle
	timeout.emit()
