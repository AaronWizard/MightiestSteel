class_name TerrainData

var _tile_date: TileData


## True if cell blocks actors from walking over it.
var blocks_walk: bool:
	get:
		return _tile_date.get_custom_data("blocks_walk")


## True if actors must spend extra movement to walk over cell.
var slows_walk: bool:
	get:
		return _tile_date.get_custom_data("slows_walk")


## True if actor gets defence bonus by standing on cell.
## Large actors need to be covering over half their area of cover cells to get
## defence bonus.
var is_cover: bool:
	get:
		return _tile_date.get_custom_data("is_cover")


## True if cell blocks attack/skill targeting and area-of-effect
var blocks_attack: bool:
	get:
		return _tile_date.get_custom_data("blocks_attack")


## True if cell blocks actors from flying over or being thrown over it.
var blocks_flight: bool:
	get:
		return _tile_date.get_custom_data("blocks_flight")


## True if actors must spend extra movement to fly or be thrown over cell.
var slows_flight: bool:
	get:
		return _tile_date.get_custom_data("slows_flight")


func _init(tile_data: TileData) -> void:
	_tile_date = tile_data
