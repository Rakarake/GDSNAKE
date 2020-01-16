extends Node

enum State {title, playing, game_over}

signal title
signal game_over
signal playing

# Use methods to set state
var _state = State.title

func _process(delta: float) -> void:
	_check_for_fullscreen()
	


func set_state_game_over() -> void:
	emit_signal("game_over")
	
	_state = State.game_over


func _check_for_fullscreen() -> void:
		if Input.is_action_just_pressed("toggle_fullscreen"):
			OS.window_fullscreen = !OS.window_fullscreen