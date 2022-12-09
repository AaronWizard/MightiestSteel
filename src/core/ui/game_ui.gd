class_name GameUI
extends CanvasLayer


var skill_info_panel: SkillInfoPanel:
	get:
		return $SkillInfoPanel


var play_area: Rect2:
	get:
		return _play_area.get_rect()


var turn_queue_button_enabled: bool:
	get:
		return not _turn_queue_button.disabled
	set(value):
		if not value:
			_turn_queue_button.button_pressed = false
		_turn_queue_button.disabled = not value


var turn_queue: TurnQueue:
	get:
		return _turn_queue


@onready var _actor_panel: ActorPanel = $ActorPanel
@onready var _other_actor_panel: ActorPanel = $OtherActorPanel

@onready var _turn_queue_button: Button = $TurnQueueButton
@onready var _turn_queue_container: MaxSizeScrollPanel = $TurnQueueContainer
@onready var _turn_queue: TurnQueue = $%TurnQueue

@onready var _play_area: Control = $PlayArea


func start_actor_turn(actor: Actor) -> void:
	_actor_panel.set_actor(actor, actor.is_player_controlled)
	_actor_panel.visible = true


func end_current_actor_turn() -> void:
	_actor_panel.clear_actor()
	_actor_panel.visible = false


func show_other_actor(actor: Actor) -> void:
	_other_actor_panel.set_actor(actor, true)
	_other_actor_panel.visible = true


func hide_other_actor() -> void:
	_other_actor_panel.clear_actor()
	_other_actor_panel.visible = false


func _on_turn_queue_button_toggled(button_pressed: bool) -> void:
	_turn_queue_container.visible = button_pressed


func _on_turn_queue_turn_index_set() -> void:
	var turn_item_pos := int(_turn_queue.turn_item_rect.position.y)
	var turn_item_half_height := int(_turn_queue.turn_item_rect.size.y / 2.0)
	var scroll_half_size := int(_turn_queue_container.scroll_size.y / 2.0)

	var scroll_pos := turn_item_pos + turn_item_half_height - scroll_half_size

	scroll_pos = maxi(scroll_pos, 0)
	scroll_pos = mini(scroll_pos, _turn_queue_container.scroll_vertical_max)

	_turn_queue_container.scroll_vertical = scroll_pos
