class_name Barrier
extends Area2D

const sprite_width = 25
var sprite_text: Texture = load("res://assets/art/platform.png")
var sprite_text_edge: Texture = load("res://assets/art/platform_edge.png")
var sprite_array = Array()

var _alliance: int
var _length
onready var _collision: CollisionShape2D
var _color = Color(0, 0, 1)

# length in tiles
func construct(pos: Vector2, length: int, alliance: int):
	position = pos
	_length = length
	var sprite_offset = 13
	
	#set collision
	var shape = RectangleShape2D.new()
	shape.set_extents(Vector2(length * 25, 25))
	_collision = CollisionShape2D.new()
	_collision.set_shape(shape)
	add_child(_collision)	# node index 0
	
	# create sprites
	var tmp = Sprite.new()
	tmp.texture = sprite_text_edge
	tmp.flip_h = true
	tmp.position.x += sprite_offset
	tmp.modulate = _color
	sprite_offset += 25
	add_child(tmp)
	for i in range(0, length - 2):
		tmp = Sprite.new()
		tmp.texture = sprite_text
		tmp.position.x += sprite_offset
		tmp.modulate = _color
		add_child(tmp)
		sprite_offset += 25
	tmp = Sprite.new()
	tmp.texture = sprite_text_edge
	tmp.position.x += sprite_offset
	tmp.modulate = _color
	add_child(tmp)
	
	# set alliance
	_alliance = alliance
	
func disable_collision():
	_collision.disabled = true
	hide()
	
func enable_collision():
	_collision.disabled = false
	show()

static func set_color(barriers: Array, alliance: int, color: Color):
	for b in barriers:
		if b._alliance == alliance:
			b._color = color
		var a = b
		a.construct(b.position, b._length, b._alliance)
		b = a
		
static func set_hide(barriers: Array, alliance: int):
	for b in barriers:
		if b._alliance == alliance:
			b.disable_collision()
		else:
			b.enable_collision()
