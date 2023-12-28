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
var normal_hit
var skill_hit
var special_hit

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
			idle = false
		if Input.is_action_just_pressed("special_skill"):
			special = true
			$AnimatedSprite2D.play("Fire")
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
				$OuchText.scale.x = -1
				flip = false
			if d == false and u == false:
				velocity.x = SPEED
			else:
				velocity.x = SPEED * sqrt(0.5)
		elif l == true:
			if !flip:
				scale.x = -scale.x
				$OuchText.scale.x = -1
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
	normal_hit = []
	skill_hit = []
	special_hit = []

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
	elif $AnimatedSprite2D.animation == "Fire":
		special = false
	$AnimatedSprite2D.play("Idle")


func _on_scratch_body_entered(body):
	#print(body.get_name())
	if body.get_name() == "Fox":
		body.hp -= 1


func _on_ouch_timer_timeout():
	$OuchText.visible = false
