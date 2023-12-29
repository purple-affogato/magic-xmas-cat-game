extends CharacterBody2D


const SPEED = 190.0
var flip = false
var hp
var playerX
var playerY
var atk

func _process(delta):
	if hp <= 0 and $DeathTimer.time_left == 0:
		get_parent().boss_dead = true
		$DeathTimer.start()
	elif get_parent().ph == get_parent().Phase.START:
		return
	if abs(playerX - self.position.x) <= 170 and abs(playerY - self.position.y) <= 100:
		velocity.x = 0
		if atk:
			$AttackTimer.start()
			atk = false
	else:
		$AnimatedSprite2D.play("walk")
		if abs(playerX - self.position.x) >= 170:
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
		if abs(playerY - self.position.y) >= 100:
			if self.position.y > playerY: # go up
				velocity.y = -SPEED
			else:
				velocity.y = SPEED
	handle_atk_animation()
	move_and_slide()

func handle_atk_animation():
	if $AnimatedSprite2D.animation == "attack" and $AnimatedSprite2D.frame_progress == 1.0:
		$AnimatedSprite2D.play("idle")
		$Attack/AOE.disabled = true
		atk = true

func _ready():
	hp = 20
	atk = true

func _on_attack_body_entered(body):
	if body.get_name() == 'Cat':
		body.get_parent().player_hp.get_node("ProgressBar").value -= 20
		body.get_node("OuchTimer").start()
		var dmg = preload("res://damage.tscn").instantiate()
		dmg.get_node("Sprite2D").frame = 1
		dmg.position = body.get_node("DMGPosition").position
		dmg.add_to_group("dmg")
		if body.flip:
			dmg.scale.x = -dmg.scale.x
		body.add_child(dmg)


func _on_attack_timer_timeout():
	$AnimatedSprite2D.play("attack")
	$Attack/AOE.disabled = false

func _on_death_timer_timeout():
	queue_free()


func _on_ouch_timer_timeout():
	for i in get_tree().get_nodes_in_group("dmg"):
		i.queue_free()
