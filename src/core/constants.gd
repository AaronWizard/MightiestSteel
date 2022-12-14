class_name Constants

const TILE_SIZE := 24
const TILE_SIZE_V := Vector2i(TILE_SIZE, TILE_SIZE)
const TILE_HALF_SIZE_V := Vector2(TILE_SIZE_V) / 2.0

const STAT_MODS := {
	Stats.ModifierTypes.DEFENCE: {
		name = "Defence",
		up = preload("res://assets/graphics/ui/icons/statmods/defence_up.png"),
		down = preload("res://assets/graphics/ui/icons/statmods/defence_down.png")
	},
	Stats.ModifierTypes.MAX_STAMINA: {
		name = "Max Stamina",
		up = preload(
				"res://assets/graphics/ui/icons/statmods/max_stamina_up.png"),
		down = preload(
				"res://assets/graphics/ui/icons/statmods/max_stamina_down.png")
	},
	Stats.ModifierTypes.ATTACK: {
		name = "Attack",
		up = preload(
				"res://assets/graphics/ui/icons/statmods/attack_up.png"),
		down = preload(
				"res://assets/graphics/ui/icons/statmods/attack_down.png")
	},
	Stats.ModifierTypes.MOVE: {
		name = "Move",
		up = preload("res://assets/graphics/ui/icons/statmods/move_up.png"),
		down = preload("res://assets/graphics/ui/icons/statmods/move_down.png")
	},
	Stats.ModifierTypes.SPEED: {
		name = "Speed",
		up = preload("res://assets/graphics/ui/icons/statmods/speed_up.png"),
		down = preload("res://assets/graphics/ui/icons/statmods/speed_down.png")
	}
}
