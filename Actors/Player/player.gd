extends CharacterBody2D

@export var move_speed: float = 200
@export var projectile_scene: Resource
@export var trident_scene: Resource

var hasTrident = true

func tridentPickup(body):
	print(body)
	if body == self:
		hasTrident = true
		get_parent().get_child(-1).queue_free()
	

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			var new_projectile = projectile_scene.instantiate()
			get_parent().add_child(new_projectile)
			var projectile_forward = Vector2.from_angle(rotation)
			new_projectile.position = $ProjectileRefPoint.global_position
			new_projectile.fire(projectile_forward, 2000)
			
		if event.button_index == 2 and event.is_pressed() and hasTrident == true:
			var new_trident = trident_scene.instantiate()
			new_trident.get_child(2).body_entered.connect(tridentPickup)
			get_parent().add_child(new_trident)
			var trident_forward = Vector2.from_angle(rotation)
			new_trident.position = $ProjectileRefPoint.global_position
			new_trident.fire(trident_forward,2000)
			hasTrident = false
func _physics_process(delta: float) -> void:
	look_at(get_viewport().get_mouse_position())

	velocity = Input.get_vector("move_left","move_right","move_up","move_down") * move_speed
	move_and_slide()
