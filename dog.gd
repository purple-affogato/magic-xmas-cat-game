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
	if self.position.x > playerX:
		if !flip:
			scale.x = -scale.x
			flip = true
	else:
		if flip:
			scale.x = -scale.x
			flip = false
	if abs(playerX - self.position.x) <= 170 and abs(playerY - self.position.y) <= 140:
		velocity.x = 0
		velocity.y = 0
		if atk:
			$AttackTimer.start()
			atk = false
	else:
		$AnimatedSprite2D.play("walk")
		if abs(playerX - self.position.x) >= 170:
			if self.position.x > playerX: # go left
				velocity.x = -SPEED
			else:
				velocity.x = SPEED
		if abs(playerY - self.position.y) >= 140:
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
		var cat = get_parent().get_node("Cat")
		if $Attack.overlaps_body(cat):
			cat.get_parent().player_hp.get_node("ProgressBar").value -= 20
			cat.get_node("OuchTimer").start()
			var dmg = preload("res://damage.tscn").instantiate()
			cat.add_child(dmg, true)
			dmg.get_node("Sprite2D").frame = 1
			dmg.position = cat.get_node("DMGPosition").position
			dmg.add_to_group("dmg")
			if cat.flip:
				dmg.scale.x = -dmg.scale.x

func _ready():
	hp = 20
	atk = true

func _on_attack_timer_timeout():
	$AnimatedSprite2D.play("attack")
	$Attack/AOE.disabled = false

func _on_death_timer_timeout():
	queue_free()


func _on_ouch_timer_timeout():
	for i in get_tree().get_nodes_in_group("dmg"):
		i.queue_free()
