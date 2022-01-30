################
#TODO
# Game is currently not well suited to multiple resolutions
# Rewrite game in C++ for performance enhancement
# make Random TileMap generator
# improve ball movement
# Add lighting to ball and tiles
################
extends Node2D

signal lvl_change

# game constants
const INITIAL_LVL_TIME = 60	# initial time between level changes
const LVL_TIME_INC = 15
const INITIAL_BARRIER_SPEED = 400

# node variables
onready var timer

# game variables
var lvl_time: float = INITIAL_LVL_TIME

func _ready():
	# start timer
	start_timer(lvl_time)
	# create new level instance
	
func start_timer(time: float):
	pass

func _on_LevelChange_timeout():
	emit_signal("lvl_change")
	lvl_time += LVL_TIME_INC
	start_timer(lvl_time)
