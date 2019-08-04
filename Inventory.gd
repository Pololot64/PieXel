extends Node


var inventory = {}

var current_block = ""

var ITEM_LIB

var selected = 0 #a number 0-7 that shows which usable item is selected. 
#The first 8 slots are usable
var api = null

func load_default(inventory_dict):
	inventory = inventory_dict
	current_block = "ax" #Placeholder... make it the selected item in inventory


func set_api(api_object):
	api = api_object
	
	
	
func get_block_dict(block_id):
	if api.ITEM_LIB.has(block_id):
		return api.ITEM_LIB[block_id]
	else:
		return null

func add_block(block_id, number):
	if block_id in inventory:
		inventory[block_id] += number
	else:
		inventory[block_id] = number
func use_block(block_id, number):
	if inventory.has(block_id):
		if inventory[block_id] >= number:
			inventory[block_id] -= number
			return true
		else:
			return false
		
	else:
		return false