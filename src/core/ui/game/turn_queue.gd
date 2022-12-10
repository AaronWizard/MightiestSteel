class_name TurnQueue
extends VBoxContainer

signal turn_index_set
signal other_actor_set
signal clicked(actor: Actor)

const _TURN_QUEUE_ITEM_SCENE = preload("res://src/core/ui/game/turn_queue_item.tscn")


## The index of the item set as the current turn actor
var turn_index: int:
	set(value):
		turn_index = value
		_set_item_borders()
		turn_index_set.emit()


## The control rect of the item representing the current turn actor
var turn_item_rect: Rect2:
	get:
		var turn_item: Control = get_child(turn_index)
		return turn_item.get_rect()


## The name of the actor node set as the selected other actor
var other_actor_name: String:
	get:
		return _other_actor_name
	set(value):
		_other_actor_name = value
		_set_item_borders()
		other_actor_set.emit()


## The control rect of the item representing the selected other actor
var other_actor_item_rect: Rect2:
	get:
		var turn_item: Control = get_node(other_actor_name)
		return turn_item.get_rect()


var _other_actor_name: String


func set_queue(map: Map, ordered_actor_names: Array[String],
		current_index: int) -> void:
	clear()
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
	turn_index = current_index


func clear() -> void:
	while get_child_count() > 0:
		var child := get_child(0)
		remove_child(child)
		child.queue_free()
	_other_actor_name = "" # Don't emit other_actor_set


func _set_item_borders() -> void:
	for i in range(get_child_count()):
		var queue_item: TurnQueueItem = get_child(i)
		queue_item.is_current = i == turn_index
		queue_item.is_other = queue_item.name == other_actor_name
