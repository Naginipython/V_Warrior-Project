extends Node

@onready var player_camera: PhantomCamera3D = %PlayerCamera
@onready var main_camera: Camera3D = %MainCamera

@export var mouse_sensitivity: float = 0.05

var mouselock = true
var min_pitch: float = -89.9
var max_pitch: float = 50
var min_yaw: float = 0
var max_yaw: float = 360

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	capture_mouse()

func _unhandled_input(event: InputEvent) -> void:
	# Capture Mouse
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		capture_mouse()
	if Input.is_key_pressed(KEY_ESCAPE):
		release_mouse()
	# Move head
	if mouselock and event is InputEventMouseMotion:
		rotate_view(event.relative)

######## My functions #######

func rotate_view(input: Vector2):
	# Code from Phantom Camera's example
	var pcam_rot: Vector3
	# Assigns the current 3D rotation of the SpringArm3D node - so it starts off where it is in the editor
	pcam_rot = player_camera.get_third_person_rotation_degrees()
	# Change the X rotation
	pcam_rot.x -= input.y * mouse_sensitivity
	# Clamp the rotation in the X axis so it go over or under the target
	pcam_rot.x = clampf(pcam_rot.x, min_pitch, max_pitch)
	# Change the Y rotation value
	pcam_rot.y -= input.x * mouse_sensitivity
	# Sets the rotation to fully loop around its target, but witout going below or exceeding 0 and 360 degrees respectively
	pcam_rot.y = wrapf(pcam_rot.y, min_yaw, max_yaw)
	# Change the SpringArm3D node's rotation and rotate around its target
	player_camera.set_third_person_rotation_degrees(pcam_rot)

func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouselock = true

func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouselock = false
