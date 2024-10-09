extends State

var detect_range: Area2D
var chasing_state: State

func initialize():
	detect_range = body.get_node("DetectionRange")
	chasing_state = get_parent().get_node("CrabChasing_Attack")
	
func on_state_entered():
	$"../../AnimationPlayer".play("idle")
	
func process_state(_delta: float):
	var potential_targets = detect_range.get_overlapping_bodies()
	if not potential_targets.is_empty():
		chasing_state.target = (potential_targets[0]) as CharacterBody2D
		change_state.emit(chasing_state)

func change_to_chase(body):
	chasing_state.target = body as CharacterBody2D
	change_state.emit(chasing_state)
	
