extends CharacterBody2D

@export var move_speed: float = 1000
@export var projectile_scene: Resource
@export var trident_scene: Resource

@onready var animPlayer = $MainSprite/AnimationPlayer
@onready var sandArea = $aimIndicCenter/Area2D

var hasTrident = true
var rolling:bool = false
var hallreg: Array = []
var hallway = preload("res://hallway.tscn")
var health: int = 3
var crab = preload("res://Actors/Enemies/Crab/crab-actor/crab.tscn")
var monkey = preload("res://Actors/Enemies/psycho monkey/monkey-actor/psycho_monkey.tscn")

func tridentPickup(body):
	if body == self:
		hasTrident = true
		get_parent().get_node("tridentBody").queue_free()
		
func hit(damg):
	if !rolling:
		$AudioStreamPlayer2D3.play()
		health -= damg
	if health == 2:
		$"../CanvasLayer/UI".get_node('Control').get_node('heart3').visible = false
	if health == 1:
		$"../CanvasLayer/UI".get_node('Control').get_node('heart2').visible = false
	if health <= 0:
		get_tree().change_scene_to_file("res://end_screen.tscn")
		
func _ready():
	randomize()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			if $aimIndicCenter/CPUParticles2D.emitting == false:
				$aimIndicCenter/CPUParticles2D.emitting = true
				$AudioStreamPlayer2D.play()
				for i in sandArea.get_overlapping_bodies():
					if i.is_in_group('enemy'):
						i.hit(1)
			
			
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
	$"../CanvasLayer/UI".get_node('Label').text = "Score: " + str(snapped($"../Camera2D".position.x - 578, 1))
	pass
	
func _physics_process(_delta: float) -> void:
	
	if (self.position.x - 576) > $"../PhantomCamera2D".limit_left:
		$"../PhantomCamera2D".set_limit_left(self.position.x - 576)
	$aimIndicCenter.look_at(get_global_mouse_position())
	var mouseRotation = abs(fmod(rad_to_deg($aimIndicCenter.rotation), 360))
	
	if rolling == true:
		if animPlayer.current_animation == "rolling" or animPlayer.current_animation == "roll_left":
			pass
		else:
			$AudioStreamPlayer2D2.play()
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


func _on_hallreg_body_entered(body):
	if body.is_in_group('walls'):
		if body.get_parent() not in hallreg:
			hallreg.append(body.get_parent)
			var new_hall = hallway.instantiate()
			$"..".add_child(new_hall)
			new_hall.position = Vector2(body.get_parent().position.x + 1152, 0)
			
			for i in range((snapped($"../Camera2D".position.x - 578, 1) / 5000)+1):
				var new_crab = crab.instantiate()
				$"..".add_child(new_crab)
				var rand_angle = randi_range(0,2*PI)
				new_crab.position = Vector2(500*cos(rand_angle), 500*sin(rand_angle))
				new_crab.get_node('States').get_node('CrabIdle').change_to_chase(self)
				
				if randi_range(1,11) % 2 == 0:
					var new_monkey = monkey.instantiate()
					$"..".add_child(new_monkey)
					new_monkey.position = Vector2(self.position.x + 500, randi_range(160,600))
					new_monkey.get_node('States').get_node('Idle').change_to_chase(self)
