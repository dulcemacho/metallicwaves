extends Node
class_name MovesRepository

@export var db : MovesDatabase

func get_root_delta_pos(animation : String, progress : float, delta : float) -> Vector3:
	var data = db.get_animation(animation)
	var track = data.find_track("MoveDatabase:root_position", Animation.TYPE_VALUE)
	if data.track_get_key_count(track) == 0:
		return Vector3.ZERO
	var previous_pos = data.value_track_interpolate(track, progress - delta)
	var current_pos = data.value_track_interpolate(track, progress)
	var delta_pos = current_pos - previous_pos
	return delta_pos

func get_duration(animation : String) -> float:
	return db.get_animation(animation).length
