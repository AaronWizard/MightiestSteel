class_name GameCamera
extends Camera2D


@onready var _bounds = self.get_viewport().get_visible_rect()


func _ready() -> void:
	@warning_ignore(return_value_discarded)
	get_tree().root.size_changed.connect(_update_bounds)


func set_bounds(rect: Rect2i) -> void:
	_bounds = rect
	_update_bounds()


func _update_bounds() -> void:
	limit_left = int(_bounds.position.x)
	limit_top = int(_bounds.position.y)

	limit_right = int(_bounds.end.x)
	limit_bottom = int(_bounds.end.y)

	var viewport := get_viewport()
	if viewport:
		var view_size := viewport.get_visible_rect().size

		if view_size.x > _bounds.size.x:
			var margin := int((view_size.x - _bounds.size.x) / 2)
			limit_left -= margin
			limit_right += margin

		if view_size.y > _bounds.size.y:
			var margin := int((view_size.y - _bounds.size.y) / 2)
			limit_top -= margin
			limit_bottom += margin
