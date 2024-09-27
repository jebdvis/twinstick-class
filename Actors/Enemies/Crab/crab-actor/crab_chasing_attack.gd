extends State

@onready var raycast = $"../../RayCast2D"

@export var chase_speed: float = 200.0
var target: CharacterBody2D


func on_enter_state():
	$"../../AnimationPlayer".play("moving")

func process_state(_delta: float):
	#gives direction in degrees: left is +/- 180, up is -90, down is 90
	var direction: float =  rad_to_deg(body.velocity.normalized().angle())
	body.velocity = (target.position - body.position).normalized() * chase_speed
	body.move_and_slide()
	
	
	raycast.global_rotation = raycast.global_position.direction_to(target.global_position).angle()-.5*PI
	var player_dist = raycast.global_position.distance_to(target.global_position)
	var wall_dist = raycast.global_position.distance_to(raycast.get_collision_point())
	print(player_dist, " and ", wall_dist)
