extends Node2D

#The user will select their biome in the menu? Maybe random?
const biome_dir = "res://Mods/Biomes/Grasslands" #Have this passed as an arg later
const map_seed = 134875

const MOD_PATH = "res://Mods/"

const modding_api = "res://modding_api.gd"

#Make these args too:
const WORLD_WIDTH = 500
const SKY_HEIGHT = 50
const GROUND_DEPTH = 100
const WORLD_HEIGHT = SKY_HEIGHT + GROUND_DEPTH


	
	
func _ready():
	#Load the API
	var api = load(modding_api)
	var dir = Directory.new()
	dir.open(MOD_PATH)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == '':
			break
		if file.ends_with(".gd"):
			print(MOD_PATH + '/' + file)
			var mod = load(MOD_PATH + '/' + file)
			print("Mod is of type: " + str(mod.mod_type))
			
			#Load map generators and then populate the world
			if mod.mod_type == "map_gen":
				#Get the biome info
				var biome_info = load(str(biome_dir) + "/biome.gd")
				var tile_set = str(biome_dir) + "//" + str(biome_info.tile_set)
				var biome = biome_info.biome
				#Generate the world
				var world = mod._on_load(map_seed, biome, WORLD_WIDTH, SKY_HEIGHT, GROUND_DEPTH, api) #TODO: Un-hardcode these XP
				
				#Build the world like we used to:
				$Ground.load_tileset(tile_set)
				$Wall.load_tileset(tile_set)
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
				
				#REMOVE THIS AS SOON AS NEW PLAYER CODE IS READY! Put the player in the center of the map
				$Player.set_position(Vector2(float(pix_width / 2), float(pix_height)))
				
				
			#Load sprite mods
			if mod.mod_type == "map_gen":
				pass #Too late fore MintFan to program... yawn
				
			#Load gaming scripts (Not on roadmap)
			
	