extends Node
class_name PlayerCamera

@export var look_at : Node3D
@export var x_sense : float
@export var y_sense : float
@export var max_y_clamp : float = 1.87
@export var min_y_clamp : float = 0.62

@onready var camera = $PlayCamera
@onready var focus_point : Node3D = $FocusPoint
@onready var camera_nest : Node3D = $CameraNest
@onready var camera_mount : Node3D = $CameraMount

var root_player : CharacterBody3D

var offset : Vector3

func _ready() -> void:
	offset = camera.global_position - focus_point.global_position

func update():
	#var new_focus = lerp( focus_point.global_position, look_at.global_position, 0.05 )
	#rotate_offset(new_focus)
	#focus_point.global_position = new_focus
	#camera_mount.global_position = lerp(camera_mount.global_position, root_player.camera_focus.global_position, 0.05 )
	#camera_nest.global_position = camera_mount.global_position + offset
	#if not camera.position.is_equal_approx(camera_nest.position):
		#camera.position = camera_nest.position
	#camera.look_at(focus_point.global_position)
	move_focus_point()
	move_camera_mount()
	move_camera()

func input_mouse_movement( d_x : float, d_y : float ):
	offset = offset.rotated(Vector3.UP, -d_x * x_sense / 1000 )
	var axis : Vector3 = offset.cross(Vector3.UP).normalized()
	var angle = d_y * y_sense / 1000
	var new_offset = offset.rotated(axis, angle)
	var new_offset_angle = new_offset.angle_to(Vector3.UP)
	if new_offset_angle < max_y_clamp and new_offset_angle > min_y_clamp:
		offset = offset.rotated(axis, angle)
	
func move_focus_point():
	var is_movement : bool = not focus_point.global_position.is_equal_approx( look_at.global_position )
	if is_movement:
		var new_focus = lerp( focus_point.global_position, look_at.global_position, 0.05 )
		rotate_offset( new_focus )
		focus_point.global_position = new_focus

func move_camera_mount():
	camera_mount.global_position = lerp( camera_mount.global_position, root_player.camera_focus.global_position, 0.05 )
	camera_nest.global_position = camera_mount.global_position + offset

func move_camera():
	if not camera.position.is_equal_approx(camera_nest.position):
		camera.position = camera_nest.position
	camera.look_at(focus_point.global_position)

func rotate_offset( new_focus : Vector3 ):
	var new_focus_projected = new_focus
	new_focus_projected.y = 0
	var old_offset_projected = -offset
	old_offset_projected.y = 0
	var center = focus_point.global_position + offset
	var center_projected = center
	center_projected.y = 0
	var new_direction = new_focus_projected - center_projected
	var alpha = new_direction.angle_to( old_offset_projected )

	var decider = new_direction.cross( old_offset_projected )
	if decider.y < 0:
		offset = offset.rotated( Vector3.UP, alpha )
	else:
		offset = offset.rotated( Vector3.UP, -alpha )
