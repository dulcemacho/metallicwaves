extends CharacterBody3D

@onready var input_collector = $Controller as InputCollector
@onready var model = $Model as CharacterModel
@onready var visuals  = $View #as PlayerVisuals
@onready var camera  = $PlayerCamera as PlayerCamera
@onready var collider  = $Collider
@onready var camera_focus: Node3D = $CameraFocus

const SPEED = 1.0
var input_data : InputPackage = InputPackage.new()

func _ready() -> void:
	camera.camera.make_current()
	camera.root_player = self

func _physics_process(delta: float) -> void:
	var input = input_collector.collect_inputs()
	var camera_motion : Vector2 = input.mouse_motion
	camera.update()
	camera.input_mouse_movement(camera_motion.x, camera_motion.y)
	
	model.update(input, delta)
	input_data.queue_free()
	input_data = input
