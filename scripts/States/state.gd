class_name State extends Node

@export var animation: String
@export var move_speed: float = 5.0

var parent: Player

func enter() -> void:
	#parent.animation_player.play(animation)
	pass

func exit() -> void:
	pass

func handle_input(event: InputEvent) -> State:
	return null

func physics_process(delta: float, dir: Vector3) -> State:
	return null

func process(delta: float) -> State:
	return null
