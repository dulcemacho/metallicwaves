extends Node
class_name MoveSet

@export var character : CharacterBody3D
@export var resources : CharacterResources
#@export var base_animator : AnimationPlayer
#@export var animator : SplitBodyAnimator
#@export var skeleton : Skeleton3D
#@export var combat : HumanoidCombat
#@export var area_awareness : AreaAwareness
#@export var moves_data_repo : MovesDataRepository
#@export var legs : Legs
#@export var left_wrist : BoneAttachment3D

var move : Dictionary # { string : Move }, where string is Move heirs name

func accept_moves():
	for child in get_children():
		if child is Move:
			move[child.label] = child
			child.character = character
			child.move_set = self
			child.resources = resources
			#child.animator = animator
			#child.skeleton = skeleton
#			child.base_animator = base_animator
			#child.combat = combat
			#child.moves_data_repo = moves_data_repo
			#child.DURATION = moves_data_repo.get_duration(child.backend_animation)
			#child.area_awareness = area_awareness
			#child.legs = legs
			#child.left_wrist = left_wrist
			#child.assign_combos()


func moves_priority_sort(a : String, b : String):
	if move[a].priority > move[b].priority:
		return true
	else:
		return false

func get_default_move() -> Move:
	var is_lowest_priority_set : bool = false
	var lowest_priority : Move
	var test : Move
	for label in move:
		test = move[label]
		
		# Needs to have a seprate bool var 
		# to avoid using lowest_priority before set
		# this error will trigger even in the condition
		# need to find cleaner alternative
		if not is_lowest_priority_set:
			lowest_priority = test
			is_lowest_priority_set = true
		
		if test.priority <= lowest_priority.priority:
			lowest_priority = test
	
	return lowest_priority


func get_move_by_name(move_name : String) -> Move:
	return move[move_name]
