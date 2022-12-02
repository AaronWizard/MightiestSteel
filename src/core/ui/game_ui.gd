class_name GameUI
extends CanvasLayer


var actor_panel: ActorPanel:
	get:
		return $ActorPanel


var other_actor_panel: ActorPanel:
	get:
		return $OtherActorPanel


var skill_info_panel: SkillInfoPanel:
	get:
		return $SkillInfoPanel


func _ready() -> void:
	GameEvents.actor_started_turn.connect(_actor_started_turn)
	GameEvents.actor_finished_turn.connect(_actor_finished_turn)


func _actor_started_turn(actor: Actor) -> void:
	actor_panel.set_actor(actor, actor.is_player_controlled)
	actor_panel.visible = true


func _actor_finished_turn(_actor: Actor) -> void:
	actor_panel.clear_actor()
	actor_panel.visible = false
