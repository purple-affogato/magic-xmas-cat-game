extends Node2D

var start_dia = [
	" ","The Past (click ENTER)",
	" ","Christmas Day, 2022",
	"Cat", "*opening presents* OMG, is this the latest state-of-the-art ball of yarn, specially designed for only the best of cat play times!",
	"Owner", "I’m glad you like the present. :D",
	"Owner", "But I also have another special gift for you. Just wait while I go get it.",
	"Cat", "Okay!",
	" ", "*Owner walks away*",
	" ", "*Boom*",
	"Cat", "!!! What was that sound?!",
	"Owner", "Be careful! The enemies of Christmas are attacking us!"]
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

func _process(delta):
	if ph == Phase.START:
		if !dia.reading:
			dia.visible = false
			ph = Phase.BATTLE
			$Cat.set_physics_process(true)
			
			
func _ready():
	$Cat/AnimatedSprite2D.play('Idle')
	ph = Phase.START
	dia = $DialogueBox
	dia.start_reading(start_dia)
	$Cat.set_physics_process(false)
