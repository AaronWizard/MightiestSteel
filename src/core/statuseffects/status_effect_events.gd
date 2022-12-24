class_name StatusEffectEvents
extends Resource

## Makes status effects respond to game events.

var _effect_nodes: Array[BaseStatusEffectNode] = []


func add_effect_node(effect_node: BaseStatusEffectNode) -> void:
	assert(_effect_nodes.find(effect_node) == -1)
	_effect_nodes.append(effect_node)


func remove_effect_node(effect_node: BaseStatusEffectNode) -> void:
	_effect_nodes.erase(effect_node)


func round_started() -> void:
	# Use duplicate of _effect_nodes to handle effects that end this round
	for n in _effect_nodes.duplicate():
		await n.round_started()


func actor_started_turn(actor: Actor) -> void:
	for n in _effect_nodes.duplicate():
		await n.actor_started_turn(actor)


func actor_moved(actor: Actor) -> void:
	for n in _effect_nodes.duplicate():
		# Since player actors can move freely within their movement range before
		# commiting an action, status effects shouldn't do animations in
		# response to movement.
		n.actor_moved(actor)


func actor_ended_turn(actor: Actor) -> void:
	for n in _effect_nodes.duplicate():
		await n.actor_ended_turn(actor)
