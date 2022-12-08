class_name TurnQueue
extends VBoxContainer

signal clicked(actor: Actor)

const _TURN_QUEUE_ITEM_SCENE = preload("res://src/core/ui/turn_queue_item.tscn")


var turn_index: int:
	set(value):
		turn_index = value
		_set_item_borders()


var other_actor_name: String:
	set(value):
		other_actor_name = value
		_set_item_borders()


func set_queue(map: Map, ordered_actor_names: Array[String],
		current_index: int) -> void:
	clear()
	turn_index = current_index
	for i in range(ordered_actor_names.size()):
		var actor_name := ordered_actor_names[i]
		var actor := map.get_actor_by_node_name(actor_name)

		var queue_item: TurnQueueItem = _TURN_QUEUE_ITEM_SCENE.instantiate()
		queue_item.name = actor.name
		add_child(queue_item)

		queue_item.portrait = actor.portrait
		queue_item.actor_name = actor.actor_name
		queue_item.is_current = i == turn_index

		queue_item.clicked.connect(func(): clicked.emit(actor))


func clear() -> void:
	while get_child_count() > 0:
		var child := get_child(0)
		remove_child(child)
		child.queue_free()
	other_actor_name = ""


func _set_item_borders() -> void:
	for i in range(get_child_count()):
		var queue_item: TurnQueueItem = get_child(i)
		queue_item.is_current = i == turn_index
		queue_item.is_other = queue_item.name == other_actor_name
