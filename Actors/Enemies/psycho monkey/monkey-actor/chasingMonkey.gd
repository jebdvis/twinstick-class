extends State

@export var chase_speed: float = 200.0
var target: CharacterBody2D

func process_state(delta: float):
	#gives direction in degrees: left is +/- 180, up is -90, down is 90
	var direction: float =  rad_to_deg(body.velocity.normalized().angle())
	var anim_player = get_parent().get_parent().get_node("AnimationPlayer")
	if anim_player.current_animation == "sleeping":
		return
	anim_controller(anim_player, direction)
	body.velocity = (target.position - body.position).normalized() * chase_speed
	body.move_and_slide()
	
func anim_controller(anim_player:AnimationPlayer, direction:float):
	if direction >= -22.5 and direction <=  22.5:
		if anim_player.current_animation != "run_right":
			anim_player.stop()
		anim_player.play("run_right")
	elif direction < -22.5 and direction >= -67.5:
		if anim_player.current_animation != "run_up_right":
			anim_player.stop()
		anim_player.play("run_up_right")
	elif direction < -67.5 and direction >= -112.5:
		if anim_player.current_animation != "run_up":
			anim_player.stop()
		anim_player.play("run_up")
	elif direction < -112.5 and direction >= -157.5:
		if anim_player.current_animation != "run_up_left":
			anim_player.stop()
		anim_player.play("run_up_left")
	elif direction < -157.5 or direction >= 157.5:
		if anim_player.current_animation != "run_left":
			anim_player.stop()
		anim_player.play("run_left")
	elif direction < 157.5 and direction >= 112.5:
		if anim_player.current_animation != "run_down_left":
			anim_player.stop()
		anim_player.play("run_down_left")
	elif direction < 112.5 and direction >= 67.5:
		if anim_player.current_animation != "run_down":
			anim_player.stop()
		anim_player.play("run_down")
	elif direction < 67.5 and direction > 22.5:
		if anim_player.current_animation != "run_down_right":
			anim_player.stop()
		anim_player.play("run_down_right")


		
		
