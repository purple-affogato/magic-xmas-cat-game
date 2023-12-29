extends CharacterBody2D


const SPEED = 180.0
var playerX
var flip = false
var hp
var atk

func _process(_delta):
	if hp <= 0 and $DeathTimer.time_left == 0:
		$DeathTimer.start()
	if abs(playerX - self.position.x) >= 170:
		$AnimatedSprite2D.play("walk")
		if self.position.x > playerX: # go left
			velocity.x = -SPEED
			if flip:
				scale.x = -scale.x
				flip = false
		else:
			if !flip:
				scale.x = -scale.x
				flip = true
			velocity.x = SPEED
	else:
		velocity.x = 0
		if atk:
			$AttackTimer.start()
			atk = false
	handle_atk_animation()
	move_and_slide()

func _ready():
	$AnimatedSprite2D.play("idle")
	atk = true
	hp = 4

func handle_atk_animation():
	if $AnimatedSprite2D.animation == "fire" and $AnimatedSprite2D.frame_progress == 1.0:
		$AnimatedSprite2D.play("idle")
		$Fire/AOE.disabled = true
		atk = true
		var cat = get_parent().get_node("Cat")
		if $Fire.overlaps_body(cat):
			cat.get_parent().player_hp.get_node("ProgressBar").value -= 20
			cat.get_node("OuchTimer").start()
			var dmg = preload("res://damage.tscn").instantiate()
			cat.add_child(dmg, true)
			dmg.get_node("Sprite2D").frame = 1
			dmg.position = cat.get_node("DMGPosition").position
			dmg.add_to_group("dmg")
			if cat.flip:
				dmg.scale.x = -dmg.scale.x

func _on_attack_timer_timeout():
	$AnimatedSprite2D.play("fire")
	$Fire/AOE.disabled = false


func _on_ouch_timer_timeout():
	for i in get_tree().get_nodes_in_group("dmg"):
		i.queue_free()


func _on_death_timer_timeout():
	get_parent().kills += 1
	queue_free()
