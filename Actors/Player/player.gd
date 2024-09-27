extends CharacterBody2D

@export var move_speed: float = 400
@export var projectile_scene: Resource
@export var trident_scene: Resource

@onready var animPlayer = $MainSprite/AnimationPlayer

var hasTrident = true
var rolling:bool = false

func tridentPickup(body):
	if body == self:
		hasTrident = true
		get_parent().get_node("tridentBody").queue_free()
	

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			$aimIndicCenter/CPUParticles2D.emitting = true
			
		if event.button_index == 2 and event.is_pressed() and hasTrident == true:
			var new_trident = trident_scene.instantiate()
			new_trident.get_child(2).body_entered.connect(tridentPickup)
			get_parent().add_child(new_trident)
			var trident_forward = position.direction_to(get_global_mouse_position())
			new_trident.position = $aimIndicCenter/AimIndic.global_position
			new_trident.fire(trident_forward,1000)
			hasTrident = false
			
	if event.is_action_pressed("roll"):
		if velocity != Vector2(0,0):
			rolling = true
			move_speed = 600
						
func _process(_delta):
	pass
	
	
func _physics_process(_delta: float) -> void:
	$aimIndicCenter.look_at(get_global_mouse_position())
	var mouseRotation = abs(fmod(rad_to_deg($aimIndicCenter.rotation), 360))
	
	if rolling == true:
		if animPlayer.current_animation == "rolling" or animPlayer.current_animation == "roll_left":
			pass
		else:
			if (velocity.angle() < PI/2) and (velocity.angle() > -PI/2): 
				animPlayer.play("rolling")
			else:
				animPlayer.play("roll_left")
			
	else:
		if velocity.length() > 10:
			if mouseRotation < 90 or mouseRotation > 270: 
				animPlayer.play("running")
			elif mouseRotation > 90 and mouseRotation < 270:
				animPlayer.play("running_left")
		else:
			if mouseRotation > 90 and mouseRotation < 270 :
				animPlayer.play("idle_left")
			else: 
				animPlayer.play("idle_right")
		
		
		
	velocity = Input.get_vector("move_left","move_right","move_up","move_down") * move_speed
	move_and_slide()
	
			


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "rolling" or anim_name == "roll_left":
		rolling = false
		move_speed = 400
