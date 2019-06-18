extends Node2D

#The world width is the width of the whole world
const WORLD_WIDTH = 500  #How high they can build
const SKY_HEIGHT = 50#This is the world's height above ground level
const GROUND_DEPTH = 100 #How deep they can dig below the mountains

const WORLD_HEIGHT = SKY_HEIGHT + GROUND_DEPTH

const TILE_SIZE = 40#size of the tiles in pixels
#Biomes. We are saving them in the code for now.
var grasslands = {
	"_tileset":get_node("Biomes/Grasslands/grasslands.tres"),
	"_mountainous":15,  #highest mountain height in blocks
	"_landscape_smoothness":15,
	"_mineral_variety":23, #Lower = more variety
	"_surface_variety":2,
	"_vegetation_variety":2, #Lower = more variety,
	"_tree_height":15,
	"mineral":{
		"cave":{"range":[0, 15], "tile_name":"cave"},  
		"cave2":{"range":[30, 40], "tile_name":"cave"},          #Lower ranges are less likely
		"dirt_normal":{"range":[75, 87], "tile_name":"dirt"},
		"more_dirt":{"range":[15, 30], "tile_name":"dirt"},
		"gold":{"range":[87, 100], "tile_name":"gold"},
		"dirt_2":{"range":[50, 75], "tile_name":"dirt"}
	},
	"surface":{
		"dirt_grass":{"range":[0, 100], "tile_name":"dirt_grass"}
		#"pond":{"range":[70, 100], "tile_name":"water"},
	},
	
	"vegetation":{
		"flower":{"range":[30, 40], "tile_name":"rose"},
		"tree":{"range":[10, 25], "tile_name":"tree"},
		"rock":{"range":[85, 100], "tile_name":"rock"},
		"bush":{"range":[40, 45], "tile_name":"bush"},
		"sapling":{"range":[45, 50], "tile_name":"sapling"},
		"mushroom":{"range":[50, 52], "tile_name":"mushroom"},
		"grass":{"range":[52, 70], "tile_name":"grass"}
	},
	"tree":{
		"sapling":"",
		"base":"dirt_stump",
		"trunk":"trunk",
		"leaves":{"mid_left":"leaf_mid_left", "mid_right":"leaf_mid_right", "left":"leaf_left", "right":"leaf_right", "top":"leaf_top"},
		"grid":[["left", "top", "right"],
				["left", "mid_left", "top", "mid_right", "right"]]
	},
	"_special_well":[["cobblestone", "water", "cobblestone"],
					["cobblestone", "water", "cobblestone"]],
}

func get_tile(noise, biome, layer):
	var normalized_noise =  int((((noise + 1) / 2) / 1.0) * 100)
	var block_types = biome[layer]
	for block in block_types:
		if normalized_noise >= block_types[block]["range"][0] and normalized_noise < block_types[block]["range"][1]:
			return block_types[block]["tile_name"]
	
	#Catch any errors. Return air if there is no assigned block type
	return ""
		

		
func save_world():
	# Excellent way of saving i must say :P
	pass
	
func load_world():
	pass

func generate_world(map_seed, biome):
	#Start by generating landfform heights and filling the ground with dirt/minerals
	if len(str(map_seed)) > 4:
		map_seed = 5678
	var mountain_max_height = biome["_mountainous"]
	
	#This is the noise used to make the mountains
	var land_noise = OpenSimplexNoise.new()
	land_noise.seed = map_seed
	land_noise.octaves = 1
	land_noise.period = biome["_landscape_smoothness"]
	land_noise.lacunarity = 0.3
	land_noise.persistence = 0.2
	
	#get ground heights
	var ground_heights = []
	for x in WORLD_WIDTH:
		var height_noise = land_noise.get_noise_2d(float(x), float(0))
		height_noise = (height_noise + 1) / 2
		var height = height_noise * mountain_max_height
		ground_heights.append(int(height))
	#Add features on and above the terrain's surface
	
	#surface noise generator
	var surface_noise = OpenSimplexNoise.new()
	surface_noise.seed = map_seed + 2394797983 #Make the seed different
	surface_noise.octaves = 1
	surface_noise.period = biome["_surface_variety"]
	surface_noise.lacunarity = 0.3
	surface_noise.persistence = 0.2
	
	#vegetation noise generator
	var vegetation_noise = OpenSimplexNoise.new()
	vegetation_noise.seed = map_seed + 3847590397 #Make the seed different
	vegetation_noise.octaves = 1
	vegetation_noise.period = biome["_vegetation_variety"]
	vegetation_noise.lacunarity = 0.3
	vegetation_noise.persistence = 0.2
	
	
	
	var surface = []
	var vegetation = []
	for w in WORLD_WIDTH:
		surface.append(surface_noise.get_noise_2d(float(w), float(0)))
		vegetation.append(vegetation_noise.get_noise_2d(float(w), float(0)))
		
	
	
	
	#Create a list named world and fill it. Calculate minerals at the same time
	var world = []
	var walls = []
	for h in WORLD_HEIGHT:
		var row = []
		for w in WORLD_WIDTH:
			row.append("")
		world.append(row)
		walls.append(row)
	#Noise used to generate underground area
	var mineral_noise = OpenSimplexNoise.new()
	mineral_noise.seed = map_seed + 9873459037 #Make the seed different
	mineral_noise.octaves = 1
	mineral_noise.period = biome["_mineral_variety"]
	mineral_noise.lacunarity = 0.3
	mineral_noise.persistence = 0.2
	
	for w in WORLD_WIDTH:
		#Fill the mountains with blocks
		for h in range(SKY_HEIGHT - ground_heights[w], SKY_HEIGHT):
			var block = mineral_noise.get_noise_2d(float(w), float(h))
			world[h][w] = str(get_tile(block, biome, "mineral"))
			if str(get_tile(block, biome, "mineral")) == "" or str(get_tile(block, biome, "mineral")) == "cave":
				walls[h][w] = "dirt_wall"
			
		#Fill the earth with minerals
		for h in range(SKY_HEIGHT, WORLD_HEIGHT):
			var block = mineral_noise.get_noise_2d(float(w), float(h))
			world[h][w] = str(get_tile(block, biome, "mineral"))
			
			if str(get_tile(block, biome, "mineral")) == "" or str(get_tile(block, biome, "mineral")) == "cave":
				walls[h][w] = str("dirt_wall")
			
	    #grow the grass... whatever the player will step on :-)
		world[SKY_HEIGHT - ground_heights[w]][w] = get_tile(surface[w], biome, "surface")
		
	
		
		
		#Add vegetation to the world. This includes rocks XP Could not find a better name
		var vegetation_type = get_tile(surface[w], biome, "vegetation")
		world[SKY_HEIGHT - ground_heights[w] - 1][w] = vegetation_type
		
		#Make sure nothing is growing on water...
		if get_tile(surface[w], biome, "surface") == "water":
			world[SKY_HEIGHT - ground_heights[w] - 1][w] = ""
			vegetation_type = "None"
		
		
		
		#make trees work
		if vegetation_type == "tree":
			
			var tree_height_noise = (mineral_noise.get_noise_2d(float(w), float(0)) + 1) / 2
			var tree_height = int(tree_height_noise * biome["_tree_height"])
			
			if tree_height < 4:
				tree_height = 7
			
			#make the base have a stump
			world[SKY_HEIGHT - ground_heights[w]][w] = biome["tree"]["base"]
			var current_tile = 1
			while current_tile < tree_height:
				world[SKY_HEIGHT - ground_heights[w] - current_tile][w] = biome["tree"]["trunk"]
				current_tile += 1
			
			#add top of tree
		
			
			var height_of_leaves = len(biome["tree"]["grid"])
			for y in range(0, height_of_leaves):
				var side_leaves_extend = int(len(biome["tree"]["grid"][y]) / 2.0)
				var current = -1 * side_leaves_extend
				for i in biome["tree"]["grid"][y]:
					world[SKY_HEIGHT - ground_heights[w] - tree_height + y][w + current] = biome["tree"]["leaves"][i]
					current += 1
			
		
	
		
	
	
	
	
	return world

# Called when the node enters the scene tree for the first time.
func _ready():
	var biome = grasslands
	var world = generate_world(1, biome)
	#$Ground.set_tileset(biome["_tileset"])
	#generate_world returns a 2d list. To acess the tile for pos(x, y), use world[y][x]
	for h in WORLD_HEIGHT:
		for w in WORLD_WIDTH:
			if str(world[h][w]) != "" and str(world[h][w]) != "cave":
				#print($Ground.get_tile(world[h][w]))
				$Ground.set_cellv(Vector2(w, h), $Ground.get_tile(world[h][w]))
			if str(world[h][w]) == "cave":
				$Wall.set_cellv(Vector2(w, h), $Ground.get_tile("dirt_wall"))
	$Ground.update_bitmask_region()
	$Wall.update_bitmask_region()
	#The default world position should be the (screen-height / 2) - the landform_max_height
	#max_height in pixels
	var pix_height = (SKY_HEIGHT * $Ground.get_cell_size()[1]) - ($Ground.get_cell_size()[1] * biome["_mountainous"])
	var pix_width = (WORLD_WIDTH * $Ground.get_cell_size()[0])
	
	var sky_center = (SKY_HEIGHT * $Ground.get_cell_size()[1])
	#Put the player in the center of the map
	print(pix_height)
	$Player.set_position(Vector2(float(pix_width / 2), float(pix_height)))
	#$Backdrop.center(Vector2(float(-1 * (pix_width / 2)), float()))



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

