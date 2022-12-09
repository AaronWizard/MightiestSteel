class_name ActorDefinition
extends Resource

enum _Columns
{
	NAME,
	STAMINA,
	ATTACK,
	MOVE,
	SPEED
}

@export_file("*.csv") var stats_file := ""
@export var stats_name := ""

@export var attack_skill: Skill

# Actors only have four skills
@export var skill0: Skill
@export var skill1: Skill
@export var skill2: Skill
@export var skill3: Skill


var stamina: int:
	get:
		_check_for_stats()
		return _stamina


var attack: int:
	get:
		_check_for_stats()
		return _attack


var move: int:
	get:
		_check_for_stats()
		return _move


var speed: int:
	get:
		_check_for_stats()
		return _speed


var _stamina: int
var _attack: int
var _move: int
var _speed: int

var _have_stats := false


var skills: Array[Skill]:
	get:
		var result := []
		if skill0:
			result.append(skill0)
		if skill1:
			result.append(skill1)
		if skill2:
			result.append(skill2)
		if skill3:
			result.append(skill3)
		return result


func _check_for_stats() -> void:
	if not _have_stats:
		_load_stats()
	_have_stats = true


func _load_stats() -> void:
	if stats_file.is_empty():
		push_error("'%s': stats_file required")

	if stats_name.is_empty():
		push_error("'%s': stats_name required" % self.resource_path)

	var file := FileAccess.open(stats_file, FileAccess.READ)
	var found_stats := false
	while file.get_position() < file.get_length():
		var row := file.get_csv_line()
		if row[_Columns.NAME] == stats_name:
			_stamina = int(row[_Columns.STAMINA])
			_attack = int(row[_Columns.ATTACK])
			_move = int(row[_Columns.MOVE])
			_speed = int(row[_Columns.SPEED])
			found_stats = true
			break
	if not found_stats:
		push_error("'%s': Could not find row with name '%s' in '%s'."
				% [self.resource_path, stats_name, stats_file])
