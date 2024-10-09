extends CharacterStateMachine
class_name psychoMonkey

@export var  hp: int = 3

func hit(damage_num: int):
	hp -= damage_num
	$AudioStreamPlayer2D.play()
	if hp <= 0:
		queue_free()
