#A PieXel Tool

const item_type = "tool"

const item_name = "ax" #This is a standard name...

const override_texture = false #give this block a folder of assets of the same name and make a tileset in it

#tool specific functions

const power = 5  #How strong the tool is. Number between 1 and 20. A tool can destroy anything with a hardness <= its power. If there is extra power, it destroys faster


#item functions

static func _on_activate(action):
    pass

static func _process():
   pass#WE MIGHT DELETE THIS
