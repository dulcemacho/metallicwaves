extends Node
class_name CharacterResources

@export var god_mode : bool = false

@export var health : float = 100
@export var max_health : float = 100

@export var stamina : float = 100
@export var max_stamina : float = 100
@export var stamina_regeneration_rate : float = 10  # per sec, because then we'll multiply on delta

@onready var model = $".." as CharacterModel

var dash_charges : float = 3.0
var statuses : Array[String]
const FATIQUE_TRESHOLD = 20


func update(delta : float):
	gain_stamina(stamina_regeneration_rate * delta)


func pay_resource_cost(move : Move):
	lose_stamina(move.stamina_cost)

func is_affordable(move : Move) -> bool:
	if stamina > 0 or move.stamina_cost == 0:
		return true
	return false

func lose_health(amount : float):
	if not god_mode:
		health -= amount
		if health < 1:
			model.current_move.try_force_move("death")


func gain_health(amount : float):
	if health + amount <= max_health:
		health += amount
	else:
		health = max_health


func lose_stamina(amount : float):
	if not god_mode:
		stamina -= amount
		if stamina < 1:
			statuses.append("fatique")

func gain_stamina(amount : float):
	if stamina + amount < max_stamina:
		stamina += amount
	else:
		stamina = max_stamina
	if stamina > FATIQUE_TRESHOLD:
		statuses.erase("fatique")

func lose_dash_charge():
	if not god_mode and dash_charges > 0.0:
		dash_charges -= 1.0

func gain_dash_charge():
	if dash_charges + 0.1 < 3.0:
		dash_charges += 0.1
