extends CharacterBody2D

@export var move_speed: float = 400
@export var projectile_scene: Resource
@export var trident_scene: Resource

@onready var animPlayer = $MainSprite/AnimationPlayer

var hasTrident = true

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
		$MainSprite.visible = false
		$Running.visible = false
		$Roll.visible = true
		$Roll.play("default")
			
func _process(delta):
	pass
	
	
func _physics_process(delta: float) -> void:
	$aimIndicCenter.look_at(get_global_mouse_position())
	var mouseRotation = rad_to_deg($aimIndicCenter.rotation)
	
	if velocity.length() > 10:
		if abs(mouseRotation) <= 90: 
			animPlayer.play("running")
		elif abs(mouseRotation) > 90:
			animPlayer.play("running_left")
	else:
		if abs(mouseRotation) <= 90: 
			animPlayer.play("idle_right")
		elif abs(mouseRotation) > 90:
			animPlayer.play("idle_left")
		
		
		
	velocity = Input.get_vector("move_left","move_right","move_up","move_down") * move_speed
	move_and_slide()
	
	var angle = rad_to_deg(velocity.angle())
	if velocity.length() < 10:
		pass
		#$MainSprite/AnimationPlayer.play("idle")
	else:
		pass
		#if angle:
			
