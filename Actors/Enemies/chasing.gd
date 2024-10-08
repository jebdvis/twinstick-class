extends State

@export var chase_speed: float = 200.0
var target: CharacterBody2D

func process_state(_delta: float):
	body.velocity = (target.position - body.position).normalized()*chase_speed
	body.move_and_slide()
