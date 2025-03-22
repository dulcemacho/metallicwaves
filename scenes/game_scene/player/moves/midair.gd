extends Move

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var down_cast: RayCast3D = $"../../DownCast"

@export var DELTA_VECTOR_LENGTH = 6
var jump_direction : Vector3

var landing_height : float = 1.5


func default_lifecycle(_input : InputPackage):
	var floor_point = down_cast.get_collision_point()
	if character.global_position.distance_to(floor_point) < landing_height:
		var xz_velocity = character.velocity
		xz_velocity.y = 0
		if xz_velocity.length_squared() >= 10:
			return "landing"
		return "landing"
	else:
		return "okay"


func update(_input : InputPackage, delta ):
	character.velocity.y -= gravity * 2.0 * delta
	character.move_and_slide()


func process_input_vector(input : InputPackage, delta : float):
	var viewport_basis = character.camera.get_node("PlayCamera").basis
	viewport_basis.z = viewport_basis.z * Vector3(1.0, 0.0, 1.0)
	var input_direction = (viewport_basis * Vector3(input.direction.x, 0, input.direction.y)).normalized()
	var input_delta_vector = input_direction * DELTA_VECTOR_LENGTH
	
	jump_direction = (jump_direction + input_delta_vector * delta).limit_length(clamp(character.velocity.length(), 1, 999999))
	character.look_at(character.global_position + jump_direction)
	
	var new_velocity = (character.velocity + input_delta_vector * delta).limit_length(character.velocity.length())
	character.velocity = new_velocity


func on_enter_state():	
	# the clamp construction is here to 
	# 1) prevent look_at annoying errors when our velocity is zero and it can't look_at properly
	# 3) have a way to scale from velocity. The longer the vector is, the harder it is to modify it by adding a delta.
	#    Scaling jump_direction with velocity is giving us that natural behaviour of faster jumps (sprints)
	#    being less controllable, and jumps from standing position being more volatile.
	#    The dependance on velocity paramter is not critical, delete this if you don't like the approach.
	jump_direction = Vector3(-character.basis.z) * clamp(character.velocity.length(), 1.0, 999999.0)
	jump_direction.y = 0.0
