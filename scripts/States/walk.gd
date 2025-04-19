extends State

@export var idle_state: State
@export var running_state: State
@export var attack1_state: State

@onready var main_camera: Camera3D = %MainCamera

func enter() -> void:
	print("walk")

func exit() -> void:
	parent.run_timer.stop()

func physics_process(delta: float, dir: Vector3) -> State:
	#print(dir)
	#if parent.run_timer.is_stopped():
		#parent.run_timer.start()
	#parent.velocity.x = dir.x * move_speed
	#parent.velocity.z = dir.z * move_speed
	## Set Rot
	#var target_yaw = atan2(dir.x, dir.z)
	#parent.rotation.y = lerp_angle(dir.y, target_yaw, delta * 10.0)
	#
	#parent.move_and_slide()
	if dir == Vector3.ZERO:
		return idle_state
	return null
