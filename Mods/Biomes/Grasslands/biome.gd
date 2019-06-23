const name = "Grasslands"
const tile_set = "grasslands.tres"
const biome_music = "placeholder.ogg"
const parallax_backgrounds = ["Layer1.png", "Layer2.png", "Layer3.png"]

const biome = {
	"_mountainous":15,  #highest mountain height in blocks
	"_landscape_smoothness":15,
	"_mineral_variety":23, #Lower = more variety
	"_surface_variety":2,
	"_vegetation_variety":2, #Lower = more variety,
	"_tree_height":15,
	"mineral":{
		"cave":{"range":[0, 15], "tile_name":"cave"},  
		"cave2":{"range":[30, 40], "tile_name":"cave"},          
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
