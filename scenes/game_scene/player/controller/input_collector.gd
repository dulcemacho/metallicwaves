extends Node
class_name InputCollector

var mouse_motion := Vector2.ZERO

func _unhandled_input(event: InputEvent) -> void:
	var is_mouse_motion := ( event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED )
	if is_mouse_motion:
			mouse_motion = event.screen_relative
			#print_debug(mouse_motion)

func collect_inputs() -> InputPackage:
	if Input.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
	if Input.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	var new_input := InputPackage.new()
	
	new_input.mouse_motion = mouse_motion
	# Prevents mouse motion drift
	mouse_motion = Vector2.ZERO
	
	# defaults to idle state
	new_input.actions.append("idle")

	new_input.direction = Input.get_vector("left", "right", "forward", "backward")
	if new_input.direction != Vector2.ZERO:
		new_input.actions.append("run")
		if Input.is_action_pressed("sprint"):
			new_input.actions.append("sprint")
		if Input.is_action_just_pressed("dash"):
			new_input.actions.append("dash")
			
	if Input.is_action_pressed("jump"):
		new_input.actions.append("jump")
		

		
	return new_input
	
