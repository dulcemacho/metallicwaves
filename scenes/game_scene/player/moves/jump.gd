extends Move

@export var ACCELERATION : float
@export var SPEED : float
const TRANSITION_TIMING = 0.44  
const JUMP_TIMING = 0.1
var jumped : bool = false

func default_lifecycle(_input : InputPackage):
	if works_longer_than(TRANSITION_TIMING):
		jumped = false
		return "midair"
	else: 
		return "okay"


func update(_input : InputPackage, _delta ):
	process_jump()
	character.move_and_slide()


func process_jump():
	if works_longer_than(JUMP_TIMING):
		if not jumped:
			character.velocity = -(character.basis.z) * SPEED 
			character.velocity.y += ACCELERATION
			jumped = true

func on_enter_state():
	character.velocity = character.velocity.normalized() * SPEED
