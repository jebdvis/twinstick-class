extends CharacterBody2D

@onready var pickupArea = $pickupArea
@onready var back_collision = $pickupArea/backCollision

func fire(forward: Vector2, speed: float):
	velocity = forward * speed
	look_at(position + forward)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(get_parent())
	var collision = move_and_collide(velocity*delta)
	if collision:
		back_collision.disabled = false
		velocity = Vector2(0,0)

		
