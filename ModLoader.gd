extends Node2D

#The user will select their biome in the menu? Maybe random?

#For Linux Exporting use user as the access path

const access_path = ""

const biome_dir = access_path + "Mods/Biomes/Grasslands" #Have this passed as an arg later
const map_seed = 3232

const MOD_PATH = access_path + "Mods/"



#Make these args too:
const WORLD_WIDTH = 300
const SKY_HEIGHT = 50
const GROUND_DEPTH = 200
const WORLD_HEIGHT = SKY_HEIGHT + GROUND_DEPTH

var api

var WORLD = []
	

		
func _ready():
	#Load the API
	api = $API
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
				WORLD = world
				
				
	
				var Ground = get_node("Ground")
				var Wall = get_node("Wall")
				Ground.load_tileset(tile_set)
				Wall.load_tileset(tile_set)
				
				api.prepare(WORLD)
				
				for h in WORLD_HEIGHT:
					for w in WORLD_WIDTH:
						if str(world[h][w]) != "":
							#print($Ground.get_tile(world[h][w]))
							Ground.set_cellv(Vector2(w, h), Ground.get_tile(world[h][w]))
						if api.mapgen_get_type(str(world[h][w]), biome) == "mineral":
							if h < SKY_HEIGHT + GROUND_DEPTH / 2:
								Wall.set_cellv(Vector2(w, h + int(biome["_mountainous"] / 2)), Ground.get_tile("dirt_wall"))
							else:
								if world[h][w] != "cave":
								    Wall.set_cellv(Vector2(w, h), Ground.get_tile("dirt_wall"))
				Ground.update_bitmask_region()
				Wall.update_bitmask_region()
				#The default world position should be the (screen-height / 2) - the landform_max_height
				#max_height in pixels
				var pix_height = (SKY_HEIGHT * Ground.get_cell_size()[1]) - (Ground.get_cell_size()[1] * biome["_mountainous"])
				var pix_width = (WORLD_WIDTH * Ground.get_cell_size()[0])
				
				var sky_center = (SKY_HEIGHT * Ground.get_cell_size()[1])
				
				Ground.set_position(Vector2(0, 0))
				
				#REMOVE THIS AS SOON AS NEW PLAYER CODE IS READY! Put the player in the center of the map
				$Player.set_position(Vector2(float(ttp(WORLD_WIDTH) / 2), float(pix_height)))
				
				#$Background1.set_position(Vector2(float(pix_width / 2), float(pix_height)))
				
				$Player.set_api(api)
				
				#Prepare the camera limits
				$Player.set_scroll_limit(0, ttp(WORLD_HEIGHT), 0, ttp(WORLD_WIDTH))
				
				#prepare scene
				$Backdrop3.set_motion_rate(Vector2(float(0.1), float(0.1)))
				$Backdrop2.set_motion_rate(Vector2(float(0.4), float(0.4)))
				$Backdrop2.prepare(load(biome_dir + "/Backdrops/1.png"))
				#Is it working???
				$Backdrop2.set_offset(Vector2(0, ttp(0)))
				
				
				
			#Load sprite mods
			if mod.mod_type == "sprite":
				pass #Too late fore MintFan to program... yawn
				#Apparently I could not spell either...^
				
			#Load gaming scripts (Not on roadmap)
	

func ttp(tiles): #Convert tiles to pixels
	return tiles * $Ground.get_cell_size()[0]


func _input(event):
	if event is InputEventMouseButton:
		var pos = get_global_mouse_position()
		api.get_tile_pixels(pos[0], pos[1])

func _process(delta):
	#Synchronize world with the API
	WORLD = api.WORLD
	#Make backdrop match surface or subterranean
	
	if $Player.get_position()[1] < ttp(SKY_HEIGHT) + ttp(int(GROUND_DEPTH / 4)):
		$Backdrop3.prepare(load(biome_dir + "/Backdrops/2.png"))
		$Backdrop2.prepare(load(biome_dir + "/Backdrops/1.png"))
	else:
		$Backdrop3.prepare(load(biome_dir + "/Backdrops/sub.png"))
		$Backdrop2.prepare(load(biome_dir + "/Backdrops/sub_1.png"))
	

		