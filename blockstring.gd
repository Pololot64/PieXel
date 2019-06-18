func _init(mod, blockname, texture_path, stack_limit=1, block_damage=0, entity_damage=0, use_speed=0, itemstring=''):
    self.blockstring = mod + '.' + blockname + '.STACK_LIMIT:'+str(stack_limit)+'.BLOCK_DAMAGE:'+str(block_damage)+'.ENTITY_DAMAGE:'+str(entity_damage)+'.USE_SPEED:'+str(use_speed)+'.ITEMSTRING:'+str(itemstring)+'.TEXTURE:'+str(texture_path)
    self.on_use = []
func register_on_use(object:FuncRef):
	self.on_use.append(object)
func on_use(mouse_click_pos):
	for i in self.on_use:
		i.call_func(mouse_click_pos)