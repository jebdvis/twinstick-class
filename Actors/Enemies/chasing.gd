extends State

@export var chase_speed: float = 200.0
var target: CharacterBody2D

func process_state(delta: float):
	print("chasing!!!")
	body.velocity = (target.position - body.position).normalized()*chase_speed
	body.move_and_slide()
