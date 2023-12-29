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
	player_hp = $HealthBar
	player_hp.get_node("ProgressBar").value = 100
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
			player_hp.visible = true
			$SpawnTimer.start()
	elif ph == Phase.BATTLE:
		if kills >= 8:
			remove_enemies()
			$Cat.set_process(false)
			$Cat/AnimatedSprite2D.play("idle")
			dia.visible = true
			dia.start_reading(end_dia)
			ph = Phase.END
			player_hp.visible = false
			$SpawnTimer.queue_free()
			return
		handle_enemies()
	else:
		if !dia.reading:
			get_tree().change_scene_to_file("res://future_level.tscn")
	
		
		
func handle_enemies():
	var enemies = get_tree().get_nodes_in_group("enemy")
	for e in enemies:
		e.playerX = $Cat.position.x

func remove_enemies():
	var enemies = get_tree().get_nodes_in_group("enemy")
	for e in enemies:
		e.queue_free()


func _on_spawn_timer_timeout():
	var choose_enemy = randi() % 2
	var enemy
	if choose_enemy == 0:
		enemy = preload("res://fox.tscn").instantiate()
	else:
		enemy = preload("res://bird.tscn").instantiate()
	enemy.add_to_group("enemy")
	if len(get_tree().get_nodes_in_group("enemy")) < 3:
		var points = get_tree().get_nodes_in_group("spawn")
		var pos = points[randi() % points.size()].position
		add_child(enemy, true)
		enemy.position = pos
