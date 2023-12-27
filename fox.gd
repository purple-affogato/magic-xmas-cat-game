extends CharacterBody2D


const SPEED = 200.0
var playerX
var flip = false
@onready var hp = 2

func _physics_process(delta):
	if abs(playerX - self.position.x) >= 100:
		if self.position.x > playerX: # go left
			velocity.x = -SPEED
			if flip:
				scale.x = -1
				flip = false
		else:
			if !flip:
				scale.x = -1
				flip = true
			velocity.x = SPEED

	move_and_slide()
