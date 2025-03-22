extends RayCast3D

@onready var csg_sphere_3d: CSGSphere3D = $CSGSphere3D
@onready var character : CharacterBody3D = $"../.."

func _process(_delta):
	global_position = character.global_position
	csg_sphere_3d.global_position = get_collision_point()
