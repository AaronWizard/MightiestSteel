class_name SkillTargetsData

## Describe the AOE and predicted damage to any actors of all targets within a
## skill's target range.

class TargetInfo:
	## Describe the AOE and predicted damage to any actors of a skill's target.

	var aoe: Array[Vector2i]:
		get:
			return _aoe

	var _aoe: Array[Vector2i]
	var _predicted_damage := {}


	## For new_predicted_damage, keys are Actors and values are ints. Negative
	## values indicate healing.
	func _init(new_aoe: Array[Vector2i], new_predicted_damage: Dictionary) \
			-> void:
		_aoe = new_aoe
		_predicted_damage = new_predicted_damage


	func get_predicted_damage(actor: Actor) -> int:
		var result := 0
		if _predicted_damage.has(actor):
			result = _predicted_damage[actor]
		return result


	func add(other: TargetInfo) -> void:
		for c in other._aoe:
			if not _aoe.has(c):
				_aoe.append(c)

		for a in other._predicted_damage:
			if _predicted_damage.has(a):
				_predicted_damage[a] += other._predicted_damage[a]
			else:
				_predicted_damage[a] = other._predicted_damage[a]


## The origin cell of the actor with the skill this SkillTargetsData is
## describing.
var source_cell: Vector2i:
	get:
		return _source_cell


## All cells that may potentially be targeted by the skill.
## What is shown on the map to the player.
##
## e.g. If a skill has a range of four cells but can only target actors, this
## contains all cells within four cells regardless of whether actors are on them
## or not.
var target_range: Array[Vector2i]:
	get:
		return _target_range


## All cells that may actually be targeted by the actor using the skill.
##
## e.g. If a skill has a range of four cells but can only target actors, this
## contains only the origin cells of the actors within range.
var valid_targets: Array[Vector2i]:
	get:
		return _valid_targets


var _source_cell: Vector2i
var _target_range: Array[Vector2i]
var _valid_targets: Array[Vector2i]
var _target_infos: Dictionary


## For target_infos, keys are Vector2is and values are TargetInfos.
func _init(new_source_cell: Vector2i, new_target_range: Array[Vector2i],
		new_valid_targets: Array[Vector2i], new_target_infos: Dictionary) \
		-> void:
	_source_cell = new_source_cell
	_target_range = new_target_range
	_valid_targets = new_valid_targets
	_target_infos = new_target_infos


func get_target_info(target: Vector2i) -> TargetInfo:
	var result: TargetInfo = null
	if _target_infos.has(target):
		result = _target_infos[target]
	return result
