class_name ActorDefinition
extends Resource

## An actor's maximum stamina
@export_range(1, 1, 1, "or_greater") var stamina := 4

## How much damage an actor's attacks do
@export_range(1, 1, 1, "or_greater") var attack := 1

## The max range in tiles an actor can move as an action
@export_range(0, 1, 1, "or_greater") var move := 4

## Modifies an actor's turn initiative
@export_range(0, 1, 1, "or_greater") var speed := 0

## How many actions (moves, attacks) an actor may take on its turn
@export_range(1, 1, 1, "or_greater") var actions := 2

@export var attack_skill: Skill

# Actors only have four skills
@export var skill0: Skill
@export var skill1: Skill
@export var skill2: Skill
@export var skill3: Skill

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
