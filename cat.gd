extends CharacterBody2D


const SPEED = 250.0
var flip = false
var dir_cnt
var d
var u
var r
var l
var idle

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


func _physics_process(delta):
	get_input()
	if dir_cnt > 2 or dir_cnt == 0 or (l == true and r == true) or (u == true and d == true):
		idle = true
	else:
		idle = false
	if idle == true:
		$AnimatedSprite2D.play('Idle')
		velocity.x = 0
		velocity.y = 0
	else:
		if r == true:
			if flip:
				scale.x = -1
				flip = false
			if d == false and u == false:
				velocity.x = SPEED
			else:
				velocity.x = SPEED * sqrt(0.5)
		elif l == true:
			if !flip:
				scale.x = -1
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
