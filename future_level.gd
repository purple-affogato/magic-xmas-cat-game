extends Node2D

var start_dia = [
	"(Press ENTER)", "The Future",
	"Date", "Christmas Day 2023",
	"Cat", "Here I am just when the clock strikes midday, but where is the big guy? Can’t believe they’re late. *rolls eyes*",
	"The Boss", "You called?",
	"Cat", "Who are you?",
	"The Boss", "I’m the Boss of Christmas Despair, but you can just call me The Boss.",
	"Cat", "Well then I’ll stop you where you stand!",
	"Tutorial", "Good news! You've unlocked a new special skill that lets you spit fire! Click R to use it."]

var end_dia = [
	"Cat", "Another day, another slay. B)",
	"Cat", "From the Past, I learned to appreciate the Christmas Spirit. From the Present, I learned how to defend against the Enemies of Christmas.",
	"Cat", "And by conquering the future, I change my destiny and become a better cat-son."
]

enum Phase {START, BATTLE, END}
var ph
var dia
var player_hp
var boss_dead

func _process(delta):
	if ph == Phase.START:
		if !dia.reading:
			dia.visible = false
			ph = Phase.BATTLE
			$Cat.set_process(true)
			player_hp.visible = true
			$BGM.stream = load("res://Assets/battle_bgm.ogg")
			$BGM.play(0.0)
			handle_boss()
		else:
			if dia.label.text == "You called?":
				if $Dog.position.x > 700:
					dia.set_process(true)
					$Dog/AnimatedSprite2D.play("idle")
					$blockades/left.disabled = false
				else:
					dia.set_process(false)
					$Dog.position.x += 200 * delta
				
	elif ph == Phase.BATTLE:
		if boss_dead:
			$Cat/AnimatedSprite2D.play("Idle")
			$Cat.set_process(false)
			dia.visible = true
			dia.start_reading(end_dia)
			ph = Phase.END
			player_hp.visible = false
			$BGM.stream = load("res://Assets/dialogue_bgm.ogg")
			$BGM.play(0.0)
			return
		handle_boss()
	else:
		if !dia.reading:
			get_tree().change_scene_to_file("res://win_game.tscn")

func handle_boss():
	$Dog.playerX = $Cat.position.x
	$Dog.playerY = $Cat.position.y

func _ready():
	$Cat/AnimatedSprite2D.play('Idle')
	ph = Phase.START
	dia = $DialogueBox
	dia.start_reading(start_dia)
	$Cat.set_process(false)
	player_hp = $HealthBar
	player_hp.get_node("ProgressBar").value = 100
	boss_dead = false
	$Dog/AnimatedSprite2D.play("walk")


func _on_quit_button_pressed():
	get_tree().change_scene_to_file("menu.tscn")
