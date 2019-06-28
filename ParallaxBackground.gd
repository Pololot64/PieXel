extends ParallaxBackground

func _ready():
	pass # Replace with function body.

func get_tile(tile_name):
	return $Tiles.tile_set.find_tile_by_name(tile_name)
	
func load_tileset(tileset_path):
	$Tiles.set_tileset(load(tileset_path))