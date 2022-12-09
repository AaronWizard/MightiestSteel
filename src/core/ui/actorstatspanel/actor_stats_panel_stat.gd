@tool
class_name ActorStatsPanelStat
extends HBoxContainer


@export var icon: Texture2D:
	set(value):
		icon = value
		if _icon:
			_icon.texture = value


@export var stat_name := "Stat":
	set(value):
		stat_name = value
		if _stat_name:
			_stat_name.text = value


@export var stat_value := 0:
	set(value):
		if _stat_value:
			stat_value = value
			_stat_value.text = str(stat_value)


@export var stat_mod := 0:
	set(value):
		if _stat_mod:
			stat_mod = value
			_stat_mod.visible = stat_mod != 0
			if stat_mod > 0:
				_stat_mod.text = "(+%d)" % stat_mod
			elif stat_mod < 0:
				_stat_mod.text = "(%d)" % stat_mod


@onready var _icon: TextureRect = $Icon
@onready var _stat_name: Label = $MarginContainer/HBoxContainer/StatName
@onready var _stat_value: Label = $MarginContainer/HBoxContainer/StatValue
@onready var _stat_mod: Label = $MarginContainer/HBoxContainer/StatMod


func _ready() -> void:
	icon = icon
	stat_name = stat_name
