extends CharacterBody2D


const SPEED = 200.0
var playerX
var flip = false
@onready var hp = 2
var atk

func _process(_delta):
	if hp <= 0:
		#print('oof')
		queue_free()
	if abs(playerX - self.position.x) >= 80:
		$AnimatedSprite2D.play("walk")
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
	else:
		velocity.x = 0
		if $AttackTimer.time_left == 0:
			$AnimatedSprite2D.play("fire")
			$Fire/AOE.disabled = false
			$AttackTimer.start()
			atk = false
		
	handle_atk()
	move_and_slide()

func _ready():
	$AnimatedSprite2D.play("idle")
	atk = true

func handle_atk():
	if $AnimatedSprite2D.frame_progress == 1.0:
		atk = false
		$AnimatedSprite2D.play("idle")
		$Fire/AOE.disabled = true

func _on_attack_timer_timeout():
	atk = true


func _on_fire_body_entered(body):
	if body.get_name() == 'Cat':
		body.get_parent().player_hp -= 1
