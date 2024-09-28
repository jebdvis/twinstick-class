extends State


@export var chase_speed: float = 200.0
var target: CharacterBody2D
var teleport: State

func initialize():
	teleport = get_parent().get_node("CrabTeleportin")


func on_enter_state():
	teleport.target = target
	$"../../AnimationPlayer".play("moving")

func process_state(_delta: float):
	if $"../..".position.distance_to(target.position) > 250:
		change_state.emit(teleport)
	#gives direction in degrees: left is +/- 180, up is -90, down is 90
	var direction: float =  rad_to_deg(body.velocity.normalized().angle())
	body.velocity = (target.position - body.position).normalized() * chase_speed
	body.move_and_slide()
	
