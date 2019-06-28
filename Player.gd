extends KinematicBody2D

const GRAVITY_VEC = Vector2(0, 2000)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 25
const MIN_ONAIR_TIME = 0.1
const WALK_SPEED = 250 # pixels/sec
const JUMP_SPEED = 900
const SIDING_CHANGE_SPEED = 10

const player_size = Vector2(1.5, 1.5)

var linear_vel = Vector2()
var onair_time = 0 #
var on_floor = false


var anim=""

var api = null

var limits = [0, 10000, -10000, 10000]

#cache the sprite here for fast access (we will set scale to flip it often)
onready var sprite = $Sprite

func get_cam_pos():
	return $Camera2D.get_camera_position()

func set_scroll_limit(up, down, left, right):
	
	#up
	get_node("Camera2D").set_limit(1, up)
	#down
	get_node("Camera2D").set_limit(3, down)
	#left
	get_node("Camera2D").set_limit(0, left)
	#right
	get_node("Camera2D").set_limit(2, right)
	
	limits = [up, down, left, right]

func set_api(api_object):
	api = api_object

func _physics_process(delta):
	#increment counters

	onair_time += delta
	#print(get_position())
	#$Haze.set_position(Vector2(float(get_position()[0]), float(7500)))
	### MOVEMENT ###

	# Apply Gravity
	linear_vel += delta * GRAVITY_VEC
	# Move and Slide
	if get_position()[0] > limits[2] and get_position()[0] < limits[3]:
		linear_vel = move_and_slide(linear_vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	
	elif get_position()[0] < limits[2] or get_position()[0] > limits[3]:
		#Stop at left edge
		if get_position()[0] < limits[2]:
		    set_position(Vector2(float(limits[2] + 1), float(get_position()[1])))
		#at right edge
		elif get_position()[0] > limits[3]:
		    set_position(Vector2(float(limits[3] - 1), float(get_position()[1])))
	
	# Detect Floor
	if is_on_floor():
		onair_time = 0

	on_floor = onair_time < MIN_ONAIR_TIME

	### CONTROL ###
	
	# Horizontal Movement
	var target_speed = 0
	if Input.is_action_pressed("left"):
		target_speed += -1
		
	if Input.is_action_pressed("right"):
		target_speed +=  1

	target_speed *= WALK_SPEED
	linear_vel.x = lerp(linear_vel.x, target_speed, 0.1)
	#print("b" + str(linear_vel.x))
	# Jumping
	if on_floor and Input.is_action_just_pressed("up"):
		linear_vel.y = -JUMP_SPEED
	

	

	### ANIMATION ###
    
	var new_anim = "idle"

	if on_floor:
		if linear_vel.x < -SIDING_CHANGE_SPEED:
			sprite.scale.x = -1 * player_size[0]
			new_anim = "run"

		if linear_vel.x > SIDING_CHANGE_SPEED:
			sprite.scale.x = 1 * player_size[0]
			new_anim = "run"
	else:
		# We want the character to immediately change facing side when the player
		# tries to change direction, during air control.
		# This allows for example the player to shoot quickly left then right.
		if Input.is_action_pressed("left") and not Input.is_action_pressed("move_right"):
			sprite.scale.x = -1 * player_size[0]
		if Input.is_action_pressed("right") and not Input.is_action_pressed("move_left"):
			sprite.scale.x = 1 * player_size[0]

		if linear_vel.y < 0:
			new_anim = "jumping"
		else:
			new_anim = "falling"

	

	if new_anim != anim:
		anim = new_anim
		$Sprite.set_animation(anim)
	
