extends State

@onready var raycast = $"../../RayCast2D"
var target: CharacterBody2D
var crab_chasing_attack: State

func initialize():
	crab_chasing_attack = get_parent().get_node("CrabChasing_Attack")

func on_enter_state():
	raycast.rotation = raycast.global_position.direction_to(target.global_position).angle() - .5 * PI
	var player_dist = raycast.global_position.distance_to(target.global_position)
	var wall_dist = raycast.global_position.distance_to(raycast.get_collision_point())
	print(raycast.rotation)
	if (.5 * player_dist) < (wall_dist - player_dist):
		var new_x = cos(raycast.rotation + (.5 * PI)) * ((.5 * player_dist) + player_dist)
		var new_y = sin(raycast.rotation+ (.5 * PI)) * ((.5 * player_dist) + player_dist)
		get_parent().get_parent().position += Vector2(new_x,new_y)
	else:
		var new_x = cos(raycast.rotation+ (.5 * PI)) * ((.5 * (wall_dist - player_dist))+player_dist)
		var new_y = sin(raycast.rotation+ (.5 * PI)) * ((.5 * (wall_dist - player_dist))+player_dist)
		get_parent().get_parent().position += Vector2(new_x,new_y)
		
	change_state.emit(crab_chasing_attack)
