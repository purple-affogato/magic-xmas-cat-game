extends Node2D

var start_dia = [
	"(Press ENTER)", "The Present",
	"Date", "Christmas Eve, 2023",
	"Cat", "What was that dream… Ah, it’s that time of year again.",
	"Cat", "Anyways, time to hunt for food. Those Enemies of Christmas are back at it again. >:(",
	"Tutorial", "Heads up! After defeating those birds from the previous level, you can now use a special Water Attack by clicking E!"
]
var end_dia = [
	"Cat", "Oh look, they left a tin of tuna behind! Not bad for a Christmas gift.",
	"Cat", "It’s times like these that I can appreciate what I have in the present and what I had in the past. Even if my owner isn’t here anymore. :(",
	"Cat", "Wait, I feel a disturbance!",
	"", "*Cue vision*",
	"Purr-phetic Voice", "O, little one, it’s time for you to face your destiny. The greatest threat to the Christmas Spirit will attack tomorrow at noon sharp!",
	"Cat", "Oh no!",
	"Purr-phetic Voice", "Take what you’ve learned from the past and present to defeat this horrible beast and avenge your owner!",
	"Cat", "This prophecy… It’s telling me the future. I must go!"
]

enum Phase {START, BATTLE, END}
var ph
var dia
var player_hp
var kills

func _ready():
	ph = Phase.START
	dia = $DialogueBox
	player_hp = 100 # placeholder value
	kills = 0
	$Cat/AnimatedSprite2D.play('Idle')
	dia.start_reading(start_dia)
	$Cat.set_process(false)
	
func _process(delta):
	if ph == Phase.START:
		if !dia.reading:
			dia.visible = false
			ph = Phase.BATTLE
			$Cat.set_process(true)