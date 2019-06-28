extends ParallaxBackground

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func prepare(image, offset=null):
	get_node("Layer/Texture").set_texture(image)
	image.set_flags(32)
	get_node("Layer").set_mirroring(image.get_size())
func set_offset(offset):
	get_node("Layer").set_motion_offset(offset)

func set_motion_rate(rate):
	get_node("Layer").set_motion_scale(rate)
	
func get_rate():
	return(get_node("Layer").get_motion_scale())
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
