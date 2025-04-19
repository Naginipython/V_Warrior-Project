extends Node

@export var starting_state: State
var current_state: State

func init(parent: Player) -> void:
	for child in get_children():
		child.parent = parent
	change_state(starting_state)

func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()
	current_state = new_state
	current_state.enter()

func physics_process(delta: float, dir: Vector3) -> void:
	var new_state = current_state.physics_process(delta, dir)
	if new_state:
		change_state(new_state)

func handle_input(event: InputEvent) -> void:
	var new_state = current_state.handle_input(event)
	if new_state:
		change_state(new_state)

func process(delta: float) -> void:
	var new_state = current_state.process(delta)
	if new_state:
		change_state(new_state)
