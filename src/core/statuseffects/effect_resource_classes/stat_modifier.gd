class_name StatModifier
extends Resource

## Actor stat modifier

@export var mod_type := Stats.ModifierTypes.MAX_STAMINA

# Want to use negative number here for range but can't:
# https://github.com/godotengine/godot/issues/41183

## The percentage to add for the modifier
@export_range(0.0, 1.0, 0.05, "or_greater", "or_less", "hide_slider") \
		var mod_value := 0.0


static func value_with_modifier(base_value: int, modifier: float) -> int:
	return int(float(base_value) * (1.0 + modifier))
