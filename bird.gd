extends CharacterBody2D


const SPEED = 200.0
var playerX
var flip = false
var hp
var atk


func _process(_delta):
	if hp <= 0 and $DeathTimer.time_left == 0:
		$DeathTimer.start()
	if abs(playerX - self.position.x) >= 170:
		$AnimatedSprite2D.play("fly_idle")
		if self.position.x > playerX: # go left
			velocity.x = -SPEED
			if !flip:
				scale.x = -scale.x
				flip = true
		else:
			if flip:
				scale.x = -scale.x
				flip = false
			velocity.x = SPEED
	else:
		velocity.x = 0
		if atk:
			$AttackTimer.start()
			atk = false
	handle_atk_animation()
	move_and_slide()

func handle_atk_animation():
	if $AnimatedSprite2D.animation == "water" and $AnimatedSprite2D.frame_progress == 1.0:
		$AnimatedSprite2D.play("fly_idle")
		$Water/AOE.disabled = true

func _ready():
	hp = 1
	atk = true

func _on_death_timer_timeout():
	get_parent().kills += 1
	queue_free()


func _on_attack_timer_timeout():
	$AnimatedSprite2D.play("water")
	$Water/AOE.disabled = false
