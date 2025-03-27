extends Move

var init_velocity: Vector3
var dashing : bool = false

func update(_input : InputPackage, delta : float) -> void:
	move_player(delta)


func move_player(delta : float) -> void:
	character.velocity = character.velocity.move_toward(character.velocity.normalized() * 10.0, 50.0 * delta)
	character.move_and_slide()


func on_enter_state() -> void:
	var input : InputPackage = character.input_data
	var viewport_basis : Basis = character.camera.get_node("PlayCamera").basis
	viewport_basis.z = viewport_basis.z * Vector3(1.0, 0.0, 1.0)
	var input_direction : Vector3 = (viewport_basis * Vector3(input.direction.x, 0, input.direction.y)).normalized()
	if input_direction:
		character.look_at(character.global_position + input_direction, Vector3.UP)
	init_velocity = character.velocity

func on_exit_state() -> void:
	character.velocity = init_velocity
