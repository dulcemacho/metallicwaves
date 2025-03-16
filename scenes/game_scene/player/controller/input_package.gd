extends Node
class_name InputPackage

var actions : Array[String]
var mouse_motion : Vector2
var direction : Vector2
var target : Vector3
var orbiting : float = 0.0

func get_orbiting() -> float:
	return orbiting
