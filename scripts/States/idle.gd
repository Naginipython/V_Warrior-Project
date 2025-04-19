extends State

@export var walk_state: State
@export var attack1_state: State

func enter() -> void:
	print("idle")
	
func physics_process(delta: float, dir: Vector3) -> State:
	print("slowing")
	parent.velocity.x = move_toward(parent.velocity.x, 0, parent.speed)
	parent.velocity.z = move_toward(parent.velocity.z, 0, parent.speed)
	
	parent.move_and_slide()
	if parent.get_dir() != Vector3.ZERO:
		return walk_state
	return null
