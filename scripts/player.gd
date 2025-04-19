class_name Player
extends CharacterBody3D

@onready var player_camera: PhantomCamera3D = %PlayerCamera
@onready var main_camera: Camera3D = %MainCamera
@onready var run_timer: Timer = $RunTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var walk_speed: float = 5.0
@export var run_speed: float = 10.0
var stop_speed: float = 10.0

enum States {IDLE, WALK, RUN, ATTACK1, ATTACK2}
var state = States.IDLE
var is_running = false
var next_attack_triggered = false

####### Builtin functions #######

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("light_attack"):
		if animation_player.current_animation.contains("Attack"):
			next_attack_triggered = true
		else:
			animation_player.play("Attack1")

func _physics_process(delta: float) -> void:
	var dir := get_dir()
	# Set state:
	match state:
		States.WALK:
			if dir == Vector3.ZERO:
				print("State: IDLE")
				state = States.IDLE
			elif is_running:
				print("State: RUN")
				state = States.RUN
		States.IDLE:
			if dir != Vector3.ZERO:
				print("State: WALK")
				state = States.WALK
		States.RUN:
			if dir == Vector3.ZERO:
				print("State: IDLE")
				state = States.IDLE
		_:
			pass
	
	# State exit
	if state != States.WALK:
		run_timer.stop()
	elif state != States.RUN:
		is_running = false
	
	match state:
		States.IDLE:
			stop_move()
		States.WALK:
			move(delta, dir, walk_speed)
		States.RUN:
			move(delta, dir, run_speed)
		_:
			pass
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()

func get_dir() -> Vector3:
	var input_dir = Input.get_vector("move_left", "move_right", "move_backward", "move_forward")
	if input_dir == Vector2.ZERO:
		return Vector3.ZERO

	var cam_transform = main_camera.global_transform.basis
	var forward = -cam_transform.z
	forward.y = 0
	forward = forward.normalized()
	var right = cam_transform.x
	right.y = 0
	right = right.normalized()

	var direction = (right * input_dir.x + forward * input_dir.y).normalized()
	return direction

func move(delta: float, dir: Vector3, speed: float):
	if run_timer.is_stopped() and speed != run_speed:
		run_timer.start()
	# Set Vel
	velocity.x = dir.x * speed
	velocity.z = dir.z * speed
	# Set Rot
	var target_yaw = atan2(dir.x, dir.z)
	rotation.y = lerp_angle(rotation.y, target_yaw, delta * 10.0)

func stop_move():
	velocity.x = move_toward(velocity.x, 0, stop_speed)
	velocity.z = move_toward(velocity.z, 0, stop_speed)

func attack_start():
	stop_move()
	next_attack_triggered = false
	match state:
		States.ATTACK1:
			print("State: ATTACK2")
			state = States.ATTACK2
		_:
			print("State: ATTACK1")
			state = States.ATTACK1

func attack_end():
	print("attack ended")
	if next_attack_triggered:
		match state:
			States.ATTACK1:
				animation_player.play("Attack2")
			_:
				state = States.IDLE
	else:
		state = States.IDLE

####### Signals #######
func _on_run_timer_timeout() -> void:
	print("Running")
	is_running = true
