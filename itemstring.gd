func _init(mod, itemname, texture_path, stack_limit=1, consumable=false, block_damage=0, entity_damage=0, use_speed=0, equipable=false, placeable=false, blockstring='',):
	self.itemstring = mod + '.' + itemname + '.STACK_LIMIT:'+str(stack_limit)+'.CONSUMABLE:'+str(consumable)+'.BLOCK_DAMAGE:'+str(block_damage)+'.ENTITY_DAMAGE:'+str(entity_damage)+'.USE_SPEED:'+str(use_speed)+'.EQUIPABLE:'+str(equipable)+'.PLACEABLE:'+str(placeable)+'.BLOCKSTRING:'+str(blockstring)+'.TEXTURE:'+str(texture_path)
	self.on_use = []
func register_on_use(object:FuncRef):
	self.on_use.append(object)
func on_use(mouse_click_pos):
	for i in self.on_use:
		i.call_func(mouse_click_pos)