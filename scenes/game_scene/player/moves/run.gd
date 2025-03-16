extends Move

@export var SPEED = 3.0
@export var TURN_SPEED = 2

func update(_input : InputPackage, _delta : float):
	character.move_and_slide()

func process_input_vector(input : InputPackage, delta : float):
	# The sutter seems to be cause what part of the camera we use to get he basis
	# It's the camera! because it's always moving toward the player it's messing with how the input_direction is set.w
	var viewport_basis = character.camera.get_node("PlayCamera").basis
	#print_debug(viewport_basis)
	#var input_direction = ( viewport_basis * Vector3(input.direction.x, 0, input.direction.y)).normalized()
	var input_direction = ( viewport_basis.z * input.direction.y + viewport_basis.x * input.direction.x ).normalized()
	var face_direction = -character.basis.z
	var angle = face_direction.signed_angle_to(input_direction, Vector3.UP)
	print_debug(" viewport basis: ", viewport_basis, " angle: ", angle, " face direction: ", face_direction, " input_direction: ", input_direction)
	if abs(angle) >= tracking_angular_speed * delta:
		# angle oscillates between negative and positive.
		var signed_angle : float = signf(angle)
		character.velocity = face_direction.rotated(Vector3.UP, signed_angle * tracking_angular_speed * delta) * TURN_SPEED
		character.rotate_y(signed_angle * tracking_angular_speed * delta)
		#print_debug("face direction: ", face_direction, " signed angle: ", signed_angle)
	else:
		#print_debug(" ELSE ")
		character.velocity = face_direction.rotated(Vector3.UP, angle) * SPEED
		character.rotate_y(angle)
		
