class_name Player
extends Node2D

signal about_to_wrap
signal wrapped

const MAX_SPEED = Vector2(400, 800)
# physics and boundries
var _velocity = Vector2.ZERO
var _x_bound: float
var _y_bound: float = 800
# nodes
onready var grounded = $Grounded
onready var camera = $Camera2D
onready var sprite = $Sprite

func _ready():
	# find boundries
	_x_bound = get_viewport_rect().size.x
	# set camera boundry
	camera.limit_right = _x_bound
	camera.limit_left = _x_bound
	# enable rays

func _process(delta):
	
	if Input.is_action_just_pressed("move_right"):
		_velocity.x = MAX_SPEED.x
	if Input.is_action_just_pressed("move_left"):
		_velocity.x = -MAX_SPEED.x
	
	if not grounded.is_colliding():
		_velocity.y = MAX_SPEED.y
	else:
		_velocity.y = 0

	# update position
	position += _velocity * delta
	# clamp x and wrap y
	position.x = clamp(position.x, 0, _x_bound)
	position.y = wrapf(position.y, 0, _y_bound)
	# rotation
	sprite.rotation += _velocity.x * delta
	
	# screen wrapping
	if (position.y + 25) >= _y_bound:
		emit_signal("about_to_wrap")
	if position.y >= _y_bound:
		emit_signal("wrapped")


