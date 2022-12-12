class_name StatModifier
extends Resource

@export var mod_type := Stats.ModifierTypes.MAX_STAMINA

# Want to use negative number here for range but can't:
# https://github.com/godotengine/godot/issues/41183

## The percentage to add for the modifier
@export_range(0.0, 1.0, 0.01, "or_greater", "or_less", "hide_slider") \
		var mod_value := 0.0
