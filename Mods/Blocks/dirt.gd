#A PieXel Block

const item_type = "block"

const item_name = "dirt" #This is a standard name...

const override_texture = false #give this block a folder of assets of the same name and make a tileset in it

#block specific functions

const hardness = 3 #How hard it is to destroy between 1 and 10
const destroy_time = 1 #How long it takes to destroy with the weakest possible tool


#item functions

static func _on_create():
    pass

static func _on_destroy():
    pass

static func _on_activate(action):
    pass

static func _process():
   pass#WE MIGHT DELETE THIS
