@tool
class_name Actor
extends TileObject

signal moved
signal attack_hit


@export var sprite_texture: Texture2D:
	get:
		return _sprite.texture
	set(value):
		if _sprite:
			_sprite.texture = value


## Name of actor instance, independant of actor's node name.
@export var actor_name := "Actor"

## Faction ID. All factions are hostile to each other.
## A faction ID of 0 is controlled by the player.
@export var faction := 0

@export var definition: ActorDefinition

@export_group("Animation")


@export var cell_offset_direction := Vector2.ZERO:
	set(value):
		cell_offset_direction = value
		_set_offset()


@export var cell_offset_distance := 0.0:
	set(value):
		cell_offset_distance = value
		_set_offset()


## Change actor's origin cell without changing its visible position nor
## triggering position-based events. Used for predicting skill effects.
var virtual_origin_cell: Vector2i:
	get:
		var result := origin_cell
		if _using_virtual_origin_cell:
			result = _virtual_origin_cell
		return result
	set(value):
		if value != origin_cell:
			_virtual_origin_cell = value
			_using_virtual_origin_cell = true


## The actor's stats
var stats: Stats:
	get:
		return $Stats


## The map the actor is currently on.
## Not meant to be set directly. Use Map.add_actor and Map.remove_actor to
## change an actor's map.
var map: Map:
	get:
		return _map
	set(value):
		if _map and (self in _map.actors):
			push_error("Actor not removed from old map using Map.remove_actor")
		if value and not (self in value.actors):
			push_error("Actor not added to new map using Map.add_actor")
		_map = value


## True if the actor is controlled by the player.
## An actor is player-controlled if its faction is 0.
var is_player_controlled: bool:
	get:
		return faction == 0


var remote_transform: RemoteTransform2D:
	get:
		return $Center/Offset/RemoteTransform2D


## Flip the sprite in the direction of the given vector
var facing: Vector2i:
	set(value):
		var diff := value - origin_cell
		if diff.x < 0:
			_sprite.flip_h = true
		elif diff.x > 0:
			_sprite.flip_h = false
		# else change nothing


## Toggle target that highlights actor
var target_visible: bool:
	get:
		return _target_cursor.visible
	set(value):
		_target_cursor.visible = value


var action_menu: ActorActionsMenu:
	get:
		return $Center/ActorActionsMenu


## Actor's standard attack. Has no cooldown.
var attack_skill: Skill:
	get:
		return _attack_skill


## All non-attack skills regardless of cooldown
var all_skills: Array[Skill]:
	get:
		return _skills.keys()


var _map: Map

var _virtual_origin_cell := Vector2i.ZERO
var _using_virtual_origin_cell := false

var _report_moves := true

var _attack_skill: Skill = null

# Keys are Skills. Values are cooldowns. Skill is valid when cooldown is 0.
var _skills := {}

@onready var _sprite: Sprite2D = $Center/Offset/Sprite
@onready var _anim: AnimationPlayer = $AnimationPlayer
@onready var _offset: Node2D = $Center/Offset

@onready var _target_cursor: TileObject = $TargetCursor


func _ready() -> void:
	if not Engine.is_editor_hint():
		if definition:
			stats.init_from_definition(definition)
			_attack_skill = definition.attack_skill
			for s in definition.skills:
				_skills[s] = s.cooldown
		_target_cursor.cell_size = cell_size

		GameEvents.round_started.connect(_round_started)


func _exit_tree() -> void:
	_map = null


func open_action_menu() -> void:
	action_menu.visible = true
	await action_menu.open(self)


func close_action_menu() -> void:
	await action_menu.close()
	action_menu.visible = false


func unset_virtual_origin_cell() -> void:
	_virtual_origin_cell = Vector2.ZERO
	_using_virtual_origin_cell = false


func move_path(path: Array[Vector2i]) -> void:
	_report_moves = false
	for next_cell in path:
		facing = next_cell
		cell_offset_direction = next_cell - origin_cell
		cell_offset_distance = -1
		origin_cell = next_cell

		_anim.play("move_step")
		await _anim.animation_finished
	_report_moves = true


func cooldown_skills() -> void:
	for s in _skills:
		if _skills[s] > 0:
			_skills[s] -= 1


func can_run_skill(skill_index: int) -> bool:
	return _skills[skill_index] == 0


func _update_size() -> void:
	super()
	if _target_cursor:
		_target_cursor.cell_size = cell_size


func _get_origin_cell() -> Vector2i:
	if _using_virtual_origin_cell:
		return virtual_origin_cell
	else:
		return super()


func _set_origin_cell(cell: Vector2i) -> void:
	unset_virtual_origin_cell()
	super(cell)
	if _report_moves:
		moved.emit()


func _set_offset() -> void:
	if _offset:
		_offset.position = cell_offset_direction.normalized() \
				* cell_offset_distance * Constants.TILE_SIZE


func _round_started(is_first_round: bool):
	if not is_first_round:
		cooldown_skills()
