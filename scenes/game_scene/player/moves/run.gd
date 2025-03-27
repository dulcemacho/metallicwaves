extends Move

@export var SPEED = 3.0
@export var TURN_SPEED = 2

func update(_input : InputPackage, _delta : float):
	character.move_and_slide()
	
func default_lifecycle(input : InputPackage):
	if not character.is_on_floor():
		return "midair" 
	
	return top_affordable_input(input)

func process_input_vector(input : InputPackage, delta : float):
	var viewport_basis = character.camera.get_node("PlayCamera").basis
	viewport_basis.z = viewport_basis.z * Vector3(1.0, 0.0, 1.0)
	var input_direction = ( viewport_basis * Vector3(input.direction.x, 0, input.direction.y)).normalized()
	var facing : Vector3 = -(character.basis.z)
	var angle : float = facing.signed_angle_to(input_direction, Vector3.UP)
	var target : Vector3 = facing.rotated(Vector3.UP, angle) * SPEED
	
	if abs(angle) >= tracking_angular_speed * delta:
		var signed_angle : float = signf(angle)
		target = facing.rotated(Vector3.UP, signed_angle * tracking_angular_speed * delta) * TURN_SPEED
		angle = (signed_angle * tracking_angular_speed * delta)

	character.velocity = character.velocity.move_toward(target, 20.0 * delta)
	character.rotate_y(angle)
	
