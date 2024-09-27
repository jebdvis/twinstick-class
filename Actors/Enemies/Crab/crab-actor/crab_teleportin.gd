extends State

@onready var raycast = $"../../RayCast2D"
var target: CharacterBody2D
var teleportState: State

func initialize():
	teleportState = get_parent().get_node("CrabTeleportin")

func on_state_entered():
	raycast.global_rotation = raycast.global_position.direction_to(target.global_position).angle()-.5*PI
	var player_dist = raycast.global_position.distance_to(target.global_position)
	
