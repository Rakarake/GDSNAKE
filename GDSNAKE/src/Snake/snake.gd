extends TileMap

enum { up = 0, down = 1, left = 2, right = 3 }
enum { head = 0, body = 4, curves = 8, tail = 12}

# References

onready var _walls :TileMap = $Walls
onready var _fruit :TileMap = $Fruit

# Public

export var tick_interval := 0.3   # In seconds, instead of speed

export var max_length := 256
export var start_length := 3
export var start_pos := Vector2(10, 15)
export var start_dir := right

# Fruit
const FRUIT_START_POS := Vector2(12, 12)
var fruit_pos := FRUIT_START_POS
var furit_rng := RandomNumberGenerator.new()
const FRUIT_BOUNDS_TOPLEFT := Vector2(9, 9)
const FRUIT_BOUNDS_BOTTOMRIGHT := Vector2(25, 25)


var _input := start_dir
var _previous_input := start_dir
var _tick_time := 0.0
var _length := 3

var _snake_tiles := []


# General idea:
#	child of the root-node: tileMap will be updated every tick
# Update tileMap: .set_cell(x, y, -1), clears the cell
#	


func _ready() -> void:
	global.connect("game_start", self, "_on_game_start")
	set_process(false)

func _on_game_start() -> void:
	print("received signal set_state_playing")
	initialize()

func initialize() -> void:
	clear()   # Clear the snake tilemap
	_fruit.clear()   # Clear the fruit tilemap
	
	# Show the title
	
	
	_length = start_length
	_input = start_dir
	_previous_input = start_dir
	_snake_tiles.resize(start_length)
	set_process(true)
	show()
	
	#TEST
	var list := [1, 2, 3, 4, 5]
	for i in range(4, 1, -1):
		var element = list[i]
		print(element)
	
	var temp_pos :Vector2 = start_pos
	for i in range(0, start_length):
		_snake_tiles[i] = SnakeTile.new()
		_snake_tiles[i].pos = temp_pos
		_snake_tiles[i].dir = start_dir
		temp_pos -= dir_int_to_vec(start_dir)
	
	# Fruit
	fruit_pos = FRUIT_START_POS
	_fruit.set_cell(FRUIT_START_POS.x, FRUIT_START_POS.y, 0)


func _process(delta: float) -> void:
	_tick_time += delta
	
	# Current input
	var expected_input
	if Input.is_action_pressed("move_up"):
		expected_input = up
	if Input.is_action_pressed("move_down"):
		expected_input = down
	if Input.is_action_pressed("move_left"):
		expected_input = left
	if Input.is_action_pressed("move_right"):
		expected_input = right
	if expected_input != null:
		_input = expected_input
	
	if _tick_time >= tick_interval:
		# Tick
		_tick_time -= tick_interval     # Resets _tick_time, if tick_interval is long: _tick_time will hop back to 0
		
		# Input handeling
		var same_dir = false
		if _input == up and _previous_input == down:
			same_dir = true
		if _input == down and _previous_input == up:
			same_dir = true
		if _input == left and _previous_input == right:
			same_dir = true
		if _input == right and _previous_input == left:
			same_dir = true
		
		if same_dir:
			_input = _previous_input
		else:
			_previous_input = _input
		
		# Empty tile
		set_cell(_snake_tiles[_length-1].pos.x, _snake_tiles[_length-1].pos.y, INVALID_CELL)   # Invalid cell is just -1
		
		# Body
		# Update positions and directions
		for i in range(_length - 1, 0, -1):   # The offsets are a little weird when iterating backwards
			var body_tile = _snake_tiles[i]
			var body_tile_up = _snake_tiles[i-1]
			body_tile.pos = body_tile_up.pos
			body_tile.dir = body_tile_up.dir
		
		# Head
		_snake_tiles[0].pos += dir_int_to_vec(_input)
		var input = _input
		_snake_tiles[0].dir = input
		for i in range(1, _length):
			var snake_tile = _snake_tiles[i]
			if snake_tile.pos == _snake_tiles[0].pos:
				print("Snake hit itself")
				die()
		
		set_cell(_snake_tiles[0].pos.x, _snake_tiles[0].pos.y, head + input)
		
		# Update body-tiles
		for i in range(1, _length-1):   # Does not take tail into consideration
			var body_tile = _snake_tiles[i]
			var body_tile_up = _snake_tiles[i-1]
			
			# Straight
			var cell_index = body + body_tile.dir
			
			# Curves
			if _check_curve(body_tile, body_tile_up, up, right, left, down):
				cell_index = curves + 0
			if _check_curve(body_tile, body_tile_up, right, down, up, left):
				cell_index = curves + 1
			if _check_curve(body_tile, body_tile_up, down, right, left, up):
				cell_index = curves + 2
			if _check_curve(body_tile, body_tile_up, right, up, down, left):
				cell_index = curves + 3
			
			set_cell(body_tile.pos.x, body_tile.pos.y, cell_index)
		
		# Tail
		var tail_object = _snake_tiles[_length-1]
		set_cell(tail_object.pos.x, tail_object.pos.y, tail + _snake_tiles[_length-2].dir)
		
		# Check walls
		if _walls.get_cell(_snake_tiles[0].pos.x, _snake_tiles[0].pos.y) != INVALID_CELL:
			print("Snake touched a wall tile")
			die()
		
		# Check fruit
		if _snake_tiles[0].pos == fruit_pos:
			elongate()


func _check_curve(tile:SnakeTile, tile_up:SnakeTile, dir1:int, dir2:int, dir3:int, dir4:int) -> bool:
	return tile.dir == dir1 && tile_up.dir == dir2 || tile.dir == dir3 && tile_up.dir == dir4


func dir_vec_to_int(v:Vector2) -> int:
	if v.y == -1:
		return 0
	if v.y == 1:
		return 1
	if v.x == -1:
		return 2
	return 3


func dir_int_to_vec(i:int) -> Vector2:
	var dir
	if i == 0:
		return Vector2(0, -1)
	if i == 1:
		return Vector2(0, 1)
	if i == 2:
		return Vector2(-1, 0)
	return Vector2(1, 0)


func elongate() -> void:
	print("elongated")
	_snake_tiles.append(SnakeTile.new())
	_length += 1
	
	# Change fruit position, dependent on FRUIT_BOUNDS
	_fruit.set_cell(fruit_pos.x, fruit_pos.y, INVALID_CELL)
	fruit_pos.x = furit_rng.randi_range(FRUIT_BOUNDS_TOPLEFT.x, FRUIT_BOUNDS_BOTTOMRIGHT.x)
	fruit_pos.y = furit_rng.randi_range(FRUIT_BOUNDS_TOPLEFT.y, FRUIT_BOUNDS_BOTTOMRIGHT.y)
	_fruit.set_cell(fruit_pos.x, fruit_pos.y, 0)


func die() -> void:
	print("you died")
	hide()
	set_process(false)
	global.set_state_game_over()
