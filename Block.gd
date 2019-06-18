extends blockstring
func _init(itemstring):
    self.itemstring = itemstring	
func _Block():
    return Block(self.itemstring)
