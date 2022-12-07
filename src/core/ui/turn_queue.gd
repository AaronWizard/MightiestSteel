class_name TurnQueue
extends VBoxContainer

signal actor_clicked(actor: Actor)

const _TURN_QUEUE_ITEM_SCENE = preload("res://src/core/ui/turn_queue_item.tscn")


var turn_index: int:
	set(value):
		turn_index = value
		_set_item_borders()


func set_queue(actors: Array[Actor], index: int) -> void:
	clear()
	turn_index = index
	for i in range(actors.size()):
		var actor := actors[i]
		var queue_item: TurnQueueItem = _TURN_QUEUE_ITEM_SCENE.instantiate()
		add_child(queue_item)
		queue_item.portrait = actor.portrait
		queue_item.actor_name = actor.actor_name
		queue_item.is_current = i == turn_index

		queue_item.clicked.connect(func(): actor_clicked.emit(actor))


func clear() -> void:
	while get_child_count() > 0:
		var child := get_child(0)
		remove_child(child)
		child.queue_free()


func _set_item_borders() -> void:
	for i in range(get_child_count()):
		var queue_item: TurnQueueItem = get_child(i)
		queue_item.is_current = i == turn_index
