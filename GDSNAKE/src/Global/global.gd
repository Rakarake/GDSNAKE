extends Node

#singleton

func _ready() -> void:
	#OS.set_window_size(Vector2(300, 300))
	pass

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen