@tool
class_name Actor
extends TileObject

## An actor.
##
## Manages its stats, skills, and animations.

## When the actor's origin cell changes
signal moved

## When the actor's attack animation reaches its "hit" frame
signal attack_hit

## When any animation finishes. Includes movement and stamina bar animations.
signal animation_finished

## When actor runs out of stamina and has finished its death animation
signal died


const FACTION_PLAYER := 0


@export var sprite_texture: Texture2D:
	get:
		return _sprite.texture
	set(value):
		if _sprite:
			_sprite.texture = value


## Character name of actor, independant of actor's node name.
@export var actor_name := "Actor"

## Faction ID. All factions are hostile to each other.
## A faction ID of 0 is controlled by the player.
@export var faction := FACTION_PLAYER

@export var definition: ActorDefinition

@export_group("Animation")


## Direction to shift actor sprite
@export var cell_offset_direction := Vector2.ZERO:
	set(value):
		cell_offset_direction = value
		_set_offset()


## Distance in cells to shift actor sprite
@export var cell_offset_distance := 0.0:
	set(value):
		cell_offset_distance = value
		_set_offset()


## Change actor's origin cell without either changing its visible position nor
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


## The actor's portrait
var portrait: Texture2D:
	get:
		var sprite := _sprite.texture
		if sprite.get_size() != Vector2(Constants.TILE_SIZE_V):
			var x := (sprite.get_size().x - Constants.TILE_SIZE) / 2

			var result := AtlasTexture.new()
			result.atlas = sprite
			result.region = Rect2(Vector2(x, 0), Constants.TILE_SIZE_V)
			return result
		else:
			return sprite


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
		return faction == FACTION_PLAYER


## A RemoteTransform2D attached to the actor's sprite
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


## Toggle alternative target that highlights actor.
## Meant for when another actor is already highlighted with its main target
## cursor.
var other_target_visible: bool:
	get:
		return _other_target_cursor.visible
	set(value):
		_other_target_cursor.visible = value


## The modifier value of the actor's stamina bar
var stamina_bar_modifier: int:
	get:
		var result := 0
		if _stamina_bar:
			result = _stamina_bar.modifier
		return result
	set(value):
		if _stamina_bar:
			_stamina_bar.modifier = value
			_stamina_bar.visible = value != 0


## The actor's action menu
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
		return _skills.duplicate()


## The actor's standard attack plus all skills with zero cooldown
var active_skills: Array[Skill]:
	get:
		var result: Array[Skill] = []
		if _attack_skill:
			result.append(_attack_skill)

		for i in range(_skills.size()):
			if _skill_cooldowns[i] == 0:
				result.append(_skills[i])

		return result


## Returns true if actor in the middle of an animation
var is_animating: bool:
	get:
		return _is_animating


var _map: Map

var _virtual_origin_cell := Vector2i.ZERO
# If true, virtual origin cell reported when accessing origin cell
var _using_virtual_origin_cell := false
# If true, actor will send moved signals when origin cell changed
var _report_moves := true

var _attack_skill: Skill = null

var _skills: Array[Skill] = []
var _skill_cooldowns := {} # Keys are ints, values are ints

var _is_animating := false

@onready var _sprite: Sprite2D = $Center/Offset/Sprite
@onready var _anim: AnimationPlayer = $AnimationPlayer
@onready var _offset: Node2D = $Center/Offset

@onready var _stamina_bar: ActorStaminaBar = $Center/Offset/ActorStaminaBar
@onready var _target_cursor: TileObject = $TargetCursor
@onready var _other_target_cursor: TileObject = $OtherTargetCursor


func _ready() -> void:
	if not Engine.is_editor_hint():
		if definition:
			stats.init_from_definition(definition)
			_attack_skill = definition.attack_skill
			_skills = definition.skills
			for i in range(_skills.size()):
				_skill_cooldowns[i] = _skills[i].cooldown

		_target_cursor.cell_size = cell_size
		_other_target_cursor.cell_size = cell_size

		_stamina_bar.max_stamina = stats.max_stamina
		_stamina_bar.set_to_full()


func _exit_tree() -> void:
	_map = null


## Open's the actor's action menu
func open_action_menu() -> void:
	action_menu.visible = true
	await action_menu.open(self)


## Closes the actor's action menu
func close_action_menu() -> void:
	await action_menu.close()
	action_menu.visible = false


## Clears the actor's virtual origin cell.
func unset_virtual_origin_cell() -> void:
	_virtual_origin_cell = Vector2.ZERO
	_using_virtual_origin_cell = false


## Moves the actor along the given path of cells
func move_path(path: Array[Vector2i]) -> void:
	_is_animating = true

	_report_moves = false

	for next_cell in path:
		facing = next_cell
		cell_offset_direction = next_cell - origin_cell
		cell_offset_distance = -1
		origin_cell = next_cell

		_anim.play("move_step")
		await _anim.animation_finished

	_report_moves = true
	moved.emit()

	_is_animating = false
	animation_finished.emit()


## Runs the actor's standard attack animation, aimed at the given target.
func animate_attack(target: Vector2i) -> void:
	_is_animating = true

	facing = target
	cell_offset_direction = target - origin_cell
	_anim.play("attack")
	await _anim.animation_finished

	_is_animating = false
	animation_finished.emit()


## Cooldowns all skills
func cooldown_skills() -> void:
	for i in _skill_cooldowns:
		_skill_cooldowns[i] = maxi(_skill_cooldowns[i] - 1, 0)


## Returns true if the skill at the given index can be run
func can_run_skill(skill_index: int) -> bool:
	return get_skill_cooldown(skill_index) == 0


func get_skill_cooldown(skill_index: int) -> int:
	return _skill_cooldowns[skill_index]


## Actor updates to run when a new round starts
func start_round(is_first_round: bool) -> void:
	if not is_first_round:
		cooldown_skills()


## Predict how much damage the actor will take.
## Takes into account attack power and source (i.e. direction) of attack
func predict_damage(attack_power: int, _source_cell: Vector2i) -> int:
	# TODO
	return attack_power


## Damage actor.
## Takes into account attack power and source (i.e. direction) of attack
func take_damage(attack_power: int, source_cell: Vector2i) -> void:
	var damage := predict_damage(attack_power, source_cell)
	stats.current_stamina -= damage


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


func _update_size() -> void:
	super()
	if _target_cursor:
		_target_cursor.cell_size = cell_size
	if _other_target_cursor:
		_other_target_cursor.cell_size = cell_size
	if _stamina_bar:
		_stamina_bar.position = Vector2(
			0, (-cell_size * Constants.TILE_SIZE_V.y) / 2.0
		)


func _set_offset() -> void:
	if _offset:
		_offset.position = cell_offset_direction.normalized() \
				* cell_offset_distance * Constants.TILE_SIZE


func _on_stats_stamina_changed(old_stamina: int, new_stamina: int) -> void:
	_is_animating = true

	if stats.is_alive:
		if new_stamina < old_stamina:
			_anim.play("hit")

		_stamina_bar.visible = true
		await _stamina_bar.animate_change(new_stamina - old_stamina)
		_stamina_bar.visible = false

		if _anim.is_playing():
			await _anim.animation_finished
	else:
		_anim.play("death")
		await _anim.animation_finished
		died.emit()

	_is_animating = false
	animation_finished.emit()
