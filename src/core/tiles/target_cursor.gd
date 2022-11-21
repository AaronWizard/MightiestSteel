@tool
extends TileObject

@onready var _nw_corner: Node2D = $NWCorner
@onready var _ne_corner: Node2D = $NECorner
@onready var _se_corner: Node2D = $SECorner


func _update_size() -> void:
	super()
	print(cell_rect.position)
	if _nw_corner:
		_nw_corner.position = pixel_rect.position
	if _ne_corner:
		_ne_corner.position = pixel_rect.position \
				+ (pixel_rect.end * Vector2i(1, 0))
	if _se_corner:
		_se_corner.position = pixel_rect.end
