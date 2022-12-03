class_name GameUI
extends CanvasLayer


var skill_info_panel: SkillInfoPanel:
	get:
		return $SkillInfoPanel


@onready var _actor_panel: ActorPanel = $ActorPanel
@onready var _other_actor_panel: ActorPanel = $OtherActorPanel


func _ready() -> void:
	pass
	#GameEvents.actor_started_turn.connect(_actor_started_turn)
	#GameEvents.actor_finished_turn.connect(_actor_finished_turn)


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
