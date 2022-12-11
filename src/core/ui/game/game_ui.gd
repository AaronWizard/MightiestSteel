class_name GameUI
extends CanvasLayer

const _TURN_QUEUE_SCROLL_TIME := 0.25


var skill_info_panel: SkillInfoPanel:
	get:
		return $SkillInfoPanel


var play_area: Rect2:
	get:
		return _play_area.get_rect()


var panels_enabled: bool:
	set(value):
		panels_enabled = value
		if not panels_enabled:
			_turn_queue_button.button_pressed = false
		_turn_queue_button.disabled = not panels_enabled


var turn_queue: TurnQueue:
	get:
		return _turn_queue


@onready var _current_actor_info: ActorInfoPanel = $CurrentActorInfo
@onready var _other_actor_panel: ActorInfoPanel = $OtherActorInfo

@onready var _turn_queue_button: Button = $TurnQueueButton
@onready var _turn_queue_container: MaxSizeScrollPanel = $TurnQueueContainer
@onready var _turn_queue: TurnQueue = $%TurnQueue

@onready var _play_area: Control = $PlayArea


func start_actor_turn(actor: Actor) -> void:
	_current_actor_info.set_actor(actor, actor.is_player_controlled)
	_current_actor_info.visible = true


func end_current_actor_turn() -> void:
	_current_actor_info.visible = false


func show_other_actor(actor: Actor) -> void:
	_other_actor_panel.set_actor(actor, true)
	_other_actor_panel.visible = true


func hide_other_actor() -> void:
	_other_actor_panel.visible = false


func _on_turn_queue_button_toggled(button_pressed: bool) -> void:
	_turn_queue_container.visible = button_pressed


func _on_turn_queue_turn_index_set() -> void:
	_scroll_over_turn_queue_item(_turn_queue.turn_item_rect, true)


func _on_turn_queue_other_actor_set() -> void:
	var item_rect: Rect2
	if _turn_queue.other_actor_name.is_empty():
		item_rect = _turn_queue.turn_item_rect
	else:
		item_rect = _turn_queue.other_actor_item_rect

	if not _turn_queue_container.visible_scroll_child_rect.encloses(item_rect):
		_scroll_over_turn_queue_item(
				item_rect, not _turn_queue_container.visible)


func _scroll_over_turn_queue_item(item_rect: Rect2, instant: bool) -> void:
	var item_y = item_rect.position.y
	var item_half_height := item_rect.size.y / 2.0
	var scroll_half_height := _turn_queue_container.scroll_size.y / 2.0

	var scroll_y := int(item_y + item_half_height - scroll_half_height)
	scroll_y = maxi(scroll_y, 0)
	scroll_y = mini(scroll_y, _turn_queue_container.scroll_vertical_max)

	if instant:
		_turn_queue_container.scroll_vertical = scroll_y
	else:
		get_tree().create_tween().tween_property(
			_turn_queue_container, "scroll_vertical", scroll_y,
			_TURN_QUEUE_SCROLL_TIME
		).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func _on_current_actor_info_portrait_pressed() -> void:
	pass # Replace with function body.


func _on_other_actor_info_portrait_pressed() -> void:
	pass # Replace with function body.
