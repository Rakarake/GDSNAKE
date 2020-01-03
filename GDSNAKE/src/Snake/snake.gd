extends TileMap

enum { up, down, left, right }

# Public

export var max_length := 256
export var start_length := 3
export var start_pos := Vector2(8, 8)

export var tick_interval := 0.5   # In seconds, instead of speed

var _input := Vector2(0, 1)   # Starting direction: right
var _tick_time := 0.0
var _snake_tiles := []
var _length := 3


# General idea:
#	child of the root-node: tileMap will be updated every tick
# Update tileMap: .set_cell(x, y, -1), clears the cell
#	


func _ready():
	_length = start_length
	_snake_tiles.resize(max_length)
	
	#TEST
	print("YES")
	var list := [1, 2, 3, 4, 5]
	for i in range(4, 1, -1):
		var element = list[i]
		print(element)
	
	var temp_pos :Vector2 = start_pos
	for i in range(0, start_length + 1):   # +1: the erasing tile
		_snake_tiles[i] = SnakeTile.new()
		_snake_tiles[i].pos = temp_pos
		_snake_tiles[i].dir = Vector2(1, 0)
		temp_pos.x -= 1


func _process(delta: float) -> void:
	_tick_time += delta
	
	# Current input
	if Input.is_action_just_pressed("move_up"):
		_input = Vector2(0, -1)
	if Input.is_action_just_pressed("move_down"):
		_input = Vector2(0, 1)
	if Input.is_action_just_pressed("move_left"):
		_input = Vector2(-1, 0)
	if Input.is_action_just_pressed("move_right"):
		_input = Vector2(1, 0)
	
	if _tick_time >= tick_interval:
		# Tick
		_tick_time -= tick_interval     # Resets _tick_time, if tick_interval is long: _tick_time will hop back to 0
		
		# Empty tile
		var empty = _snake_tiles[_length - 1]
		set_cell(empty.pos.x, empty.pos.y, -1)
		
		# Body
		for i in range(_length - 1, 0, -1):   # The offsets are a little weird when iterating backwards
			if _snake_tiles[i] == null:
				print("element ", i, " in _snake_tiles is null")
				break
			_snake_tiles[i].pos = _snake_tiles[i-1].pos
			_snake_tiles[i].dir = _snake_tiles[i-1].dir
			set_cell(_snake_tiles[i].pos.x, _snake_tiles[i].pos.y, 0)
			print("this is: ", i)
		
		# Head
		_snake_tiles[0].pos += _input
		set_cell(_snake_tiles[0].pos.x, _snake_tiles[0].pos.y, 5)
		