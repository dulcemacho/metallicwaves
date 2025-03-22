extends Node3D
class_name CharacterModel

@onready var player: CharacterBody3D = $".."
@onready var current_move : Move
@onready var move_set = $Moves as MoveSet

func _ready():
	move_set.character = player
	move_set.accept_moves()
	current_move = move_set.get_default_move()


func update(input : InputPackage, delta : float):
	var relevance = current_move.check_relevance(input)
	if relevance != "okay":
		switch_to(relevance)
	current_move.update_resources(delta)
	current_move._update(input, delta)


func switch_to(state : String):
	current_move._on_exit_state()
	current_move = move_set.move[state]
	current_move._on_enter_state()
