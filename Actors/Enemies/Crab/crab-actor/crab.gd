extends CharacterStateMachine
class_name crab

@export var  hp: int = 5

func hit(damage_num: int):
	hp -= damage_num
	if hp <= 0:
		queue_free()
