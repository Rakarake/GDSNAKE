extends TileMap

var _pos := Vector2(18, 18)

func _ready() -> void:
	get_parent().connect("elongate", self, "_on_Snake_elongate")


func _on_Snake_elongate() -> void:
	print("hey")