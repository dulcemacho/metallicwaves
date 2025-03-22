extends Node
class_name Move

@export var label : String
@export var animation : String
@export var db_label : String #need to come up with a better name
@export var priority : int
@export var tracks_vector : bool = false
@export var tracking_angular_speed : float = 10 #need to come up with a better name
@export var stamina_cost : float = 0

var resources : CharacterResources

var enter_state_time : float
var character : CharacterBody3D
var move_set : MoveSet
var DURATION : float
var initial_position : Vector3

func _update(input : InputPackage, delta : float):
	if tracks_input_vector():
		process_input_vector(input, delta)
	update(input, delta)

func update(_input : InputPackage, _delta : float):
	pass
	
func process_input_vector(input : InputPackage, delta : float):
	var viewport_basis = character.camera.get_node("PlayCamera").basis
	viewport_basis.z = viewport_basis.z * Vector3(1.0, 0.0, 1.0)
	var input_direction = ( viewport_basis * Vector3(input.direction.x, 0, input.direction.y)).normalized()
	var face_direction = -character.basis.z
	var angle = face_direction.signed_angle_to(input_direction, Vector3.UP)
	character.rotate_y(clamp(angle, -tracking_angular_speed * delta, tracking_angular_speed * delta))

func check_relevance(input : InputPackage) -> String:
	return default_lifecycle(input)

func _on_exit_state():
	on_exit_state()

func on_exit_state():
	pass

func _on_enter_state():
	initial_position = character.global_position
	resources.pay_resource_cost(self)
	mark_enter_state()
	on_enter_state()

func mark_enter_state():
	enter_state_time = Time.get_unix_time_from_system()

func on_enter_state():
	pass

func default_lifecycle(input : InputPackage):
	if works_longer_than(DURATION):
		return best_input_that_can_be_paid(input)
	return "okay"

func get_progress() -> float:
	var now = Time.get_unix_time_from_system()
	return now - enter_state_time

func works_longer_than(time : float) -> bool:
	if get_progress() >= time:
		return true
	return false

func update_resources(delta : float):
	resources.update(delta)

func best_input_that_can_be_paid(input : InputPackage) -> String:
	input.actions.sort_custom(move_set.moves_priority_sort)
	for action in input.actions:
		if resources.can_be_paid(move_set.move[action]):
			if move_set.move[action] == self:
				return "okay"
			else:
				return action
	return "throwing because for some reason input.actions doesn't contain even idle" 
	
func tracks_input_vector():
	return tracks_vector
