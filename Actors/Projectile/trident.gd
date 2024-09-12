extends CharacterBody2D

@onready var pickupArea = $pickupArea
@onready var back_collision = $pickupArea/backCollision
@onready var animationPlayer = $AnimationPlayer
@onready var particles = $CPUParticles2D

func fire(forward: Vector2, speed: float):
	look_at(position + forward)
	animationPlayer.current_animation = "trident_shake"
	await animationPlayer.animation_finished
	particles.amount = 1000
	particles.spread = 180
	animationPlayer.play("fired")
	velocity = forward * speed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collision = move_and_collide(velocity*delta)
	if collision:
		back_collision.disabled = false
		velocity = Vector2(0,0)
		animationPlayer.stop()
		particles.emitting = false
