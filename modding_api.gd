#PieXel Modding API v0.1

static func get_tile(noise, biome, layer):  #This gets the necessary tile from the noise
	var normalized_noise =  int((((noise + 1) / 2) / 1.0) * 100)
	var block_types = biome[layer]
	for block in block_types:
		if normalized_noise >= block_types[block]["range"][0] and normalized_noise < block_types[block]["range"][1]:
			return block_types[block]["tile_name"]
	
	#Catch any errors. Return air if there is no assigned block type
	return ""