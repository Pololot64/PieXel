#PieXel Modding API v0.1
extends Node

var WORLD

var MOD_PATH

var ITEM_LIB

var environment_light = 100


func prepare(world):
	WORLD = world

func mapgen_get_tile(noise, biome, layer):  #This gets the necessary tile from the noise
	var normalized_noise =  int((((noise + 1) / 2) / 1.0) * 100)
	var block_types = biome[layer]
	for block in block_types:
		if normalized_noise >= block_types[block]["range"][0] and normalized_noise < block_types[block]["range"][1]:
			return block_types[block]["tile_name"]
	
	#Catch any errors. Return air if there is no assigned block type
	return ""
	
func set_tile(x, y, new_tile):
	WORLD[y][x] = new_tile
	get_node("../Ground").set_cellv(Vector2(x, y), get_node("../Ground").get_tile(WORLD[y][x]))
	get_node("../Ground").update_bitmask_region()

func get_tile(x, y):
	return WORLD[y][x]
	
func get_light():
	return environment_light

func set_light(lightness): #light between 0=dark and 100=light	
	environment_light = lightness
	var num = (lightness / 100.0)
	get_node("../NightMask").set_color(Color(num, num, num, 1))
	get_node("../Backdrop2").set_light(num)
	get_node("../Backdrop3").set_light(num)
	
func ttp(tiles):
	return tiles * get_node("../Ground").get_cell_size()[0]
	
func ptt(pixels):
	return int(pixels / get_node("../Ground").get_cell_size()[0])
	
func get_tile_pixels(x, y):
	var tile_pos = get_node("../Ground").world_to_map(Vector2(float(x), float(y)))
	return tile_pos
	
	
func mapgen_get_type(tile, biome):
	
	var mineral_types = []
	for t in biome["mineral"]:
		mineral_types.append(biome["mineral"][t]["tile_name"])
		
	var surface_types = []
	for t in biome["surface"]:
		surface_types.append(biome["surface"][t]["tile_name"])
		
	var vegetation_types = []
	for t in biome["vegetation"]:
		vegetation_types.append(biome["vegetation"][t]["tile_name"])
		
	if tile in mineral_types:
		return "mineral"
	elif tile in surface_types:
		return "surface"
	elif tile in vegetation_types:
		return "vegetation"
	else:
		return ""
	