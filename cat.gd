extends CharacterBody2D


const SPEED = 250.0
var flip = false
var dir_cnt
var d
var u
var r
var l
var idle
var normal
var skill
var special

func get_input():
	dir_cnt = 0
	d = false
	u = false
	l = false
	r = false
	if Input.is_action_pressed("ui_down"):
		d = true
		dir_cnt += 1
	if Input.is_action_pressed("ui_up"):
		u = true
		dir_cnt += 1
	if Input.is_action_pressed("ui_left"):
		l = true
		dir_cnt += 1
	if Input.is_action_pressed("ui_right"):
		r = true
		dir_cnt += 1
	if !is_attacking():
		if Input.is_action_just_pressed("normal_attack"):
			normal = true
			$AnimatedSprite2D.play("Scratch")
			$Scratch/AOE.disabled = false
			idle = false
		if Input.is_action_just_pressed("skill"):
			skill = true
			$AnimatedSprite2D.play("Tail Whip")
			$Whip/AOE.disabled = false
			idle = false
		if Input.is_action_just_pressed("water_skill") and get_parent().name != "PastLevel":
			special = true
			$AnimatedSprite2D.play("Water")
			idle = false

func _process(_delta):
	get_input()
	handle_attack_animation()
	#print($CollisionShape2D.position)
	if is_attacking():
		idle = false
	elif dir_cnt > 2 or dir_cnt == 0 or (l == true and r == true) or (u == true and d == true):
		idle = true
	else:
		idle = false
	if idle == true:
		$AnimatedSprite2D.play('Idle')
		velocity.x = 0
		velocity.y = 0
	elif !is_attacking():
		if r == true:
			if flip:
				scale.x = -scale.x
				flip = false
			if d == false and u == false:
				velocity.x = SPEED
			else:
				velocity.x = SPEED * sqrt(0.5)
		elif l == true:
			if !flip:
				scale.x = -scale.x
				flip = true
			if d == false and u == false:
				velocity.x = -SPEED
			else:
				velocity.x = -SPEED * sqrt(0.5)
		if u == true:
			if l == false and r == false:
				velocity.y = -SPEED
			else:
				velocity.y = -SPEED * sqrt(0.5)
		elif d == true:
			if l == false and r == false:
				velocity.y = SPEED
			else:
				velocity.y = SPEED * sqrt(0.5)
		$AnimatedSprite2D.play("Walk")
	move_and_slide()

func  _ready():
	normal = false
	skill = false
	special = false

func is_attacking():
	if normal or skill or special:
		return true
	return false
	
func handle_attack_animation():
	if $AnimatedSprite2D.frame_progress < 1.0:
		return
	if $AnimatedSprite2D.animation == "Scratch":
		normal = false
		$Scratch/AOE.disabled = true
	elif $AnimatedSprite2D.animation == "Tail Whip":
		skill = false
		$Whip/AOE.disabled = true
	elif $AnimatedSprite2D.animation == "Fire":
		special = false
	$AnimatedSprite2D.play("Idle")


func _on_scratch_body_entered(body):
	#print(body.get_name())
	if body.get_name() == "Fox" or body.get_name() == "Bird":
		body.hp -= 1
		var dmg = preload("res://damage.tscn").instantiate()
		body.add_child(dmg)
		dmg.get_node("Sprite2D").frame = 1
		dmg.position = body.get_node("DMGPosition").position
		dmg.add_to_group("dmg")
		body.get_node("OuchTimer").start()

func _on_ouch_timer_timeout():
	for i in get_tree().get_nodes_in_group("dmg"):
		i.queue_free()


func _on_whip_body_entered(body):
	if body.get_name() == "Fox" or body.get_name() == "Bird":
		body.hp -= 1
		var dmg = preload("res://damage.tscn").instantiate()
		body.add_child(dmg)
		dmg.get_node("Sprite2D").frame = 1
		dmg.position = body.get_node("DMGPosition").position
		dmg.add_to_group("dmg")
		body.get_node("OuchTimer").start()
