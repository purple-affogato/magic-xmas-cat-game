extends Control



func _on_play_pressed():
	get_tree().change_scene_to_file("past_level.tscn")



func _on_quit_pressed():
	get_tree().quit()


func _on_credits_button_pressed():
	get_tree().change_scene_to_file("credits.tscn")
