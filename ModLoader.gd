extends Node2D

#The user will select their biome in the menu? Maybe random?

#For Linux Exporting use user as the access path

const access_path = ""

const biome_dir = access_path + "Mods/Biomes/Grasslands" #Have this passed as an arg later
const map_seed = 3232

const MOD_PATH = access_path + "Mods"



#Make these args too:
const WORLD_WIDTH = 300
const SKY_HEIGHT = 50
const GROUND_DEPTH = 200
const WORLD_HEIGHT = SKY_HEIGHT + GROUND_DEPTH

var api

var WORLD = []

var last_acted = Vector2(0, 0) #The last block that was edited

var mouse_held_time = 0 #how many loops the mouse has been held

var action_distance = 8 #How many blocks away can something be hit

onready var player = get_node("Player")
			

func dir_loader(PATH):
	var dir = Directory.new()
	dir.open(PATH)
	dir.list_dir_begin()
	var mods = []
	while true:
		var file = dir.get_next()
		if file == '':
			break
		else:
			mods.append(file)
	return mods
	
func _ready():
	#Load the API
	api = $API
	
	api.MOD_PATH = MOD_PATH
	
	api.set_light(100)
	
	var mods = dir_loader(MOD_PATH)
	
	for mod_path in mods:
		if mod_path.ends_with(".gd"):
			var mod = load(MOD_PATH + "/" + mod_path)
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
				$Selected.set_position(Vector2(0, 0))
				
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
			if mod.mod_type == "ai":
				pass #Too late fore MintFan to program... yawn
				#Apparently I could not spell either...^
			
			#Load gaming scripts
			if mod.mod_type == "game":
				player.inventory.load_default(mod.starting_inventory)
			
	
	#load blocks
	var blocks = dir_loader(MOD_PATH + "/Blocks")
	var item_lib = {}
	for block_path in blocks:
		if block_path.ends_with(".gd"):
			var block_object = load(MOD_PATH + "/Blocks/" + block_path)
			if block_object.item_type == "block":
				var block = {
					"item_name":block_object.item_name,
					"item_type":"block",
					"hardness":block_object.hardness,
					"destroy_time":block_object.destroy_time
				}
				item_lib[block["item_name"]] = block
			elif block_object.item_type == "tool":
				var block = {
					"item_name":block_object.item_name,
					"item_type":"tool",
					"power":block_object.power
				}
				item_lib[block["item_name"]] = block
	api.ITEM_LIB = item_lib
	
		


func ttp(tiles): #Convert tiles to pixels
	return tiles * $Ground.get_cell_size()[0]


func _input(event):
	if event is InputEventMouseButton:
		var button = Input.get_mouse_button_mask() #1=left, 2=right, 0=up, 8=scrl_down, scrl_up=16
		
		var pos = get_global_mouse_position()
		var coords = api.get_tile_pixels(pos[0], pos[1])
		
		var regular_click = false
		
		if button == 1:
			pass
		if button == 0:
			if mouse_held_time < 0.3:
				regular_click = true
			else:
				print("mouse was held for " + str(mouse_held_time) + " seconds")
			mouse_held_time = 0
		
		if regular_click == true:
			#Since it was a click, process block action activating
			pass
			
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
		
	#make lighting work.. find more efficient way
	"""
	for h in WORLD_HEIGHT:
		for w in WORLD_WIDTH:
			if str(WORLD[h][w]) != "":
			    $Lighting.set_cellv(Vector2(w, h), 10)
	$Lighting.update_bitmask_region()
	"""
	
	#highlight mouse
	var pos = get_global_mouse_position()
	var coords = api.get_tile_pixels(pos[0], pos[1])
	var player_coords = player.get_coords()
	var distx = coords[0] - player_coords[0]
	var disty = coords[1] - player_coords[1]
	var dist = int(sqrt((distx * distx) + (disty * disty)))
	var block = api.get_tile(coords[0], coords[1])
	
	if dist >= 0 and Input.is_mouse_button_pressed(1) == false:
		var color
		if dist < action_distance and dist > 1:
			color = "green"
		elif dist >= action_distance or dist <= 1:
			color = "red"
			
		$Selected.clear()
		$Selected.set_cellv(coords, $Selected.get_tile(color))
		$Selected.update_bitmask_region()
	
	
	#work with the mouse
	if Input.is_mouse_button_pressed(1) == true:
		mouse_held_time += delta
		#Press and hold on air to keep creating blocks...
		#Press and hold on a block to delete it
		
		
		
		
		if dist > 1 and dist < action_distance and player.inventory.current_block != "" and api.ITEM_LIB.has(player.inventory.current_block):
			var current_block_type = player.inventory.get_block_dict(player.inventory.current_block)["item_type"]
			if current_block_type == "block" and block == "" and mouse_held_time > 0.3:
				mouse_held_time = 0
				
				#make sure blocks can't be built floating
				var buildable = false
				for x in range(3):
					for y in range(3):
						var coord = Vector2(coords[0] - 1 + x, coords[1] - 1 + y)
						if coord != coords:
							if api.get_tile(coord[0], coord[1]) != "":
								buildable = true
				
				
				if buildable == true and player.inventory.use_block(player.inventory.current_block, 1) == true:
					print("build")
					api.set_tile(coords[0], coords[1], player.inventory.current_block)
					print(player.inventory.inventory)
					
			if current_block_type == "tool" and block != "" and api.ITEM_LIB.has(block):
				if coords != last_acted: #Wait till there is a new coord before acting
					last_acted = coords
					mouse_held_time = 0
				var hardness = player.inventory.get_block_dict(block)["hardness"]
				var destroy_time = player.inventory.get_block_dict(block)["destroy_time"]
				var tool_power = player.inventory.get_block_dict(player.inventory.current_block)["power"]
				var final_destroy_time
				
				if tool_power >= hardness:
					if tool_power - hardness > 0:
						final_destroy_time = (1 - ((tool_power - hardness) / 20.0)) * destroy_time
					else:
						final_destroy_time = destroy_time
					
					var completed = int((mouse_held_time / final_destroy_time) * 100)
					var state = "green"
					
					if completed < 30:
						state = "d1"
					elif completed >= 30 and completed < 60:
						state = "d2"
					elif completed >= 60 and completed < 100:
						state = "d3"
					elif completed == 100:
						state = "green"
					$Selected.clear()
					$Selected.set_cellv(coords, $Selected.get_tile(state))
					$Selected.update_bitmask_region()
					
					if mouse_held_time > final_destroy_time:
						mouse_held_time = 0
						player.inventory.add_block(block, 1)
						print(player.inventory.inventory)
						print("destroy")
						api.set_tile(coords[0], coords[1], "")
		
		
		