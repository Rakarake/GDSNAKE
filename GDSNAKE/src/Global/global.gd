extends Node

enum {title, playing, game_over}

signal game_start

# References

onready var _game_over_text :RichTextLabel = get_node("/root/PlayingArea/GameOverText")
onready var _start_text :RichTextLabel = get_node("/root/PlayingArea/StartText")

# Use methods to set state
var _state := title
var game_over_counter := 0.0
const quit_game_over := 3.0


func _ready() -> void:
	set_state_title()


func _process(delta: float) -> void:
	_check_for_fullscreen()
	if _state == title && Input.is_action_just_pressed("start_game"):
		set_state_playing()
	elif _state == game_over:
		game_over_counter += delta
		if game_over_counter >= quit_game_over:
			game_over_counter = 0
			set_state_title()

func set_state_game_over() -> void:
	print("set state game over")
	_state = game_over
	_game_over_text.show()


func set_state_title() -> void:
	print("set state title")
	_state = title
	_game_over_text.hide()
	_start_text.show()


func set_state_playing() -> void:
	print("set state playing")
	_state = playing
	_start_text.hide()
	emit_signal("game_start")   # The snake initializes itself


func _check_for_fullscreen() -> void:
	if Input.is_action_just_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
