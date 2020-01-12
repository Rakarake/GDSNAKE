extends Node

enum State {title, playing, game_over}

var state = State.title

func _process(delta: float) -> void:
	_check_for_fullscreen()
	


func _check_for_fullscreen() -> void:
		if Input.is_action_just_pressed("toggle_fullscreen"):
			OS.window_fullscreen = !OS.window_fullscreen