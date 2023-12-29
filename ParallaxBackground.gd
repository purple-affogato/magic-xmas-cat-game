extends ParallaxBackground


func _process(delta):
	scroll_base_offset += Vector2(50,0)*delta


func _on_back_button_pressed():
	get_tree().change_scene_to_file("menu.tscn")
