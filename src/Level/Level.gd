extends Node2D

const BUFFER_START = 0
const BUFFER_SIZE = 32 # length of level buffer in tiles
const BUFFER_WIDTH = 19 # width of buffer in tiles
						# controls how long buffer should be before wrapping
const PLATFORM_LEN = 15	# total number of tiles the platforms can take up
const PLATFORM_SEP = 2 # number of tiles between each platform layer
const DUPLICATE_RESOLUTION = Vector2(19, 14)	# tile resolution of the duplicate sections above and below the tilemap
												# also contains the tile resolution of the top camera half

# nodes
onready var tilemap = $TileMap
onready var dupemap = $Duplicates
onready var barriers
var rng
var alliance_hide = 1

func _ready():
	# create random number generator
	rng = RandomNumberGenerator.new()
	rng.randomize()
	# generate first dupe
	generate_upper_duplicate()
	# hard-coded barriers
	barriers = [
		Barrier.new(),
		Barrier.new(),
		Barrier.new(),
		Barrier.new(),
		Barrier.new(),
		Barrier.new(),
		Barrier.new()
	]
	# construcut barriers
	barriers[0].construct(tilemap.map_to_world(Vector2(6,9)), 4, -1)
	barriers[1].construct(tilemap.map_to_world(Vector2(4,12)), 2, 1)
	barriers[2].construct(tilemap.map_to_world(Vector2(11,12)), 2, -1)
	barriers[3].construct(tilemap.map_to_world(Vector2(7,15)), 3, 1)
	barriers[4].construct(tilemap.map_to_world(Vector2(9,18)), 10, -1)
	barriers[5].construct(tilemap.map_to_world(Vector2(0,24)), 3, 1)
	barriers[6].construct(tilemap.map_to_world(Vector2(7,24)), 3, 1)
	
	Barrier.set_color(barriers, 1, Color(1, 0, 0))
		
	Barrier.set_hide(barriers, alliance_hide)
	
	for b in barriers:
		add_child(b)
	
func _process(delta):
	
	if Input.is_action_just_pressed("switch"):
		alliance_hide *= -1
		for i in range(2, get_child_count()):
			remove_child(get_child(i))
		Barrier.set_hide(barriers, alliance_hide)
		for b in barriers:
			add_child(b)
	

func _on_Main_lvl_change():
	pass # change tile color

# generate initial tilemap
func generate_tilemap() -> void:
	tilemap.clear()	# remove old tilemap
	for y in range(BUFFER_START, BUFFER_SIZE, PLATFORM_SEP):
		generate_level(y)

func generate_level(tile_row: int) -> void:
	var count = (rng.randi() % 2) + 1
	# plot new tiles	
	var x = 0
	while x < BUFFER_SIZE:
		var length: int = rng.randi() % PLATFORM_LEN
			
		for j in range(x, x + length):
			tilemap.set_cell(x, tile_row, 0)
		
		x += length
		
		
# generates a lower duplicate and places it above player area
# no noticeable impact on performance but could be better
# TODO: use viewports or backbuffercopies -> might have worse performance (check)
func generate_lower_duplicate() -> void:
	dupemap.clear()
	# minus one for coordinate discrepency
	var y_offset: int = -DUPLICATE_RESOLUTION.y
	var cells = tilemap.get_used_cells()
	var y_index_offset: int = BUFFER_SIZE - DUPLICATE_RESOLUTION.y

	for cell in cells:
		if cell.y < y_index_offset || cell.y > BUFFER_SIZE:
			continue
		var y = (cell.y - y_index_offset) + y_offset
		dupemap.set_cell(cell.x, y, 0)
	
func generate_upper_duplicate() -> void:
	var y_offset: int = BUFFER_SIZE
	var cells = tilemap.get_used_cells()
	var y_index_offset: int = DUPLICATE_RESOLUTION.y

	for cell in cells:
		if cell.y > y_index_offset || cell.y < 0:
			continue
		var y = cell.y + y_offset
		dupemap.set_cell(cell.x, y, 0)

# when palyer is about to wrap, generate upper duplicate
func _on_Player_about_to_wrap():
	generate_lower_duplicate()
	generate_upper_duplicate()

func _on_Player_wrapped():
	generate_upper_duplicate()
