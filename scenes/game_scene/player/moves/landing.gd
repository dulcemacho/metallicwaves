extends Move


var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

const TRANSITION_TIMING = 0.2

# landings aren't default-defaults, this TRANSITION_TIMING != DURATION
# DURATION is much longer, but we are releasing the priority early
# and the rest of the animation is just for smoother blending
func default_lifecycle(input : InputPackage):
	character.get_quaternion()
	if works_longer_than(TRANSITION_TIMING):
		var result : String = top_affordable_input(input)
		return result
	return "okay"


func update(_input : InputPackage, delta ):
	character.velocity.y -= gravity * 2 * delta
	character.move_and_slide()
