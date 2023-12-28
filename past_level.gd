extends Node2D

var start_dia = [
	"(Click ENTER)","The Past",
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
	"Tutorial","Attack with Q and E!",
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

func _process(delta):
	if ph == Phase.START:
		if !dia.reading:
			dia.visible = false
			ph = Phase.BATTLE
			$Cat.set_process(true)
	elif ph == Phase.BATTLE:
		print(player_hp," ",kills)
		if kills >= 3:
			remove_enemies()
			$Cat.set_process(false)
			dia.visible = true
			dia.start_reading(end_dia)
			ph = Phase.END
			return
		spawn_enemies()
		handle_foxes()
	else:
		if !dia.reading:
			get_tree().change_scene_to_file("res://present_level.tscn")
			
func spawn_enemies():
	var fox = preload("res://fox.tscn").instantiate()
	if len(get_tree().get_nodes_in_group("firefox")) < 1:
		add_child(fox)
		fox.position = $SpawnPoint1.position
		fox.add_to_group("firefox")
		
func remove_enemies():
	var foxes = get_tree().get_nodes_in_group("firefox")
	for f in foxes:
		f.queue_free()

func handle_foxes():
	var foxes = get_tree().get_nodes_in_group("firefox")
	for f in foxes:
		f.playerX = $Cat.position.x

func _ready():
	$Cat/AnimatedSprite2D.play('Idle')
	ph = Phase.START
	dia = $DialogueBox
	dia.start_reading(start_dia)
	$Cat.set_process(false)
	player_hp = 100
	kills = 0
