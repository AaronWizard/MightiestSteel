class_name ActorStatsPanelSkillButton
extends Button


var cooldown: int:
	set(value):
		cooldown = value
		_cooldown.text = str(cooldown)

		_cooldown.visible = cooldown != 0
		_ready.visible = cooldown == 0


@onready var _cooldown: Label = $Cooldown
@onready var _ready: Control = $Ready
