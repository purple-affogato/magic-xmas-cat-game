extends Node2D

func _ready():
	pass

func _on_timer_timeout():
	get_tree().change_scene_to_file("res://menu.tscn")


func _on_back_button_pressed():
	get_tree().change_scene_to_file("menu.tscn")
