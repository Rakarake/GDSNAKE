extends Node

# References
onready var _tile_map :TileMap = $Grid

# Public
export var start_length := 3
export var start_pos := Vector2(4, 4)

export var tick_interval := 0.5   # In seconds, instead of speed
var tick_time := 0.0


# General idea:
#	child of the root-node: tileMap will be updated every tick
# Update tileMap: .set_cell(x, y, -1), clears the cell
#	


func _ready():
	pass


func _process(delta: float) -> void:
	tick_time += delta
	if tick_time >= tick_interval:
		# Tick
		#_tile_map.set_cell(1, 1, 0)
		pass
	pass