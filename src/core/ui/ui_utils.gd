class_name UIUtils


static func remove_signal_connections(sig: Signal) -> void:
	while not sig.get_connections().is_empty():
		var connection_data: Dictionary = sig.get_connections()[0]
		var callable: Callable = connection_data.callable
		sig.disconnect(callable)
