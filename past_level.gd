extends Node2D

var start_dia = [
	"(Press ENTER)","The Past",
	"Date","Christmas Day, 2022",
	"Cat", "*opening presents* OMG, is this the latest state-of-the-art ball of yarn, specially designed for only the best of cat play times!",
	"Owner", "I’m glad you like the present. :D",
	"Owner", "But I also have another special gift for you. Just wait while I go get it.",
	"Cat", "Okay!",
	" ", "*Owner walks away*",
	" ", "*Boom*",
	"Cat", "!!! What was that sound?!",
	"Owner", "Be careful! The enemies of Christmas are attacking us!",
	"Tutorial","Use the arrow keys to move!",
	"Tutorial","Attack by clicking Q and W!",
	"Tutorial", "But most importantly, don't die!"
	]
var end_dia = [
	" ", "*Screaming*",
	"Cat", "Oh no! What happened?!",
	"Owner", "D-don’t worry a-about m-me…",
	"Cat", "How could this happen? *Looks to the right*",
	"Cat", "What’s this?",
	" ", "A handmade gift rested on the ground near the Owner’s hand."]

enum Phase {START, BATTLE, END}
var ph
var dia
var player_hp
var kills
signal owner_offscreen

func _process(delta):
	if ph == Phase.START:
		if !dia.reading:
			dia.visible = false
			ph = Phase.BATTLE
			$Cat.set_process(true)
			player_hp.visible = true
		else:
			if dia.label.text == "*Owner walks away*":
				dia.set_process(false)
				if $Owner.position.x < -200:
					owner_offscreen.emit()
					return
				$Owner.position.x -= 200 * delta
	elif ph == Phase.BATTLE:
		if player_hp.get_node("ProgressBar").value <= 0:
			get_tree().change_scene_to_file("res://game_over.tscn")
			return
		print(kills)
		if kills >= 5:
			remove_enemies()
			$Cat.set_process(false)
			$Cat/AnimatedSprite2D.play("idle")
			dia.visible = true
			dia.start_reading(end_dia)
			ph = Phase.END
			player_hp.visible = false
			return
		spawn_enemies()
		handle_birds()
	else:
		if !dia.reading:
			get_tree().change_scene_to_file("res://present_level.tscn")
			
func spawn_enemies():
	var bird = preload("res://bird.tscn").instantiate()
	if len(get_tree().get_nodes_in_group("waterbird")) < 2:
		add_child(bird, true)
		bird.position = $SpawnPoint.position
		bird.add_to_group("waterbird")
		
func remove_enemies():
	var birds = get_tree().get_nodes_in_group("waterbird")
	for b in birds:
		b.queue_free()

func handle_birds():
	var birds = get_tree().get_nodes_in_group("waterbird")
	for b in birds:
		b.playerX = $Cat.position.x

func _ready():
	$Cat/AnimatedSprite2D.play('Idle')
	ph = Phase.START
	dia = $DialogueBox
	dia.start_reading(start_dia)
	$Cat.set_process(false)
	player_hp = $HealthBar
	player_hp.get_node("ProgressBar").value = 100
	kills = 0


func _on_owner_offscreen():
	dia.set_process(true)


func _on_quit_button_pressed():
	get_tree().change_scene_to_file("menu.tscn")
