extends Control

@onready var label = $Dialogue
@onready var speaker = $Speaker
var dialogue = []
var idx = 0
var reading = false

func start_reading(array):
	dialogue = array
	idx = 1
	label.text = dialogue[idx]
	speaker.text = dialogue[idx-1]
	reading = true
	handle_sfx()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not visible:
		return
	if reading == true and Input.is_action_just_released("ui_accept"):
		idx += 2
		if idx >= len(dialogue):
			reading = false
			visible = false
		else:
			label.text = dialogue[idx]
			speaker.text = dialogue[idx-1]
			handle_sfx()
			
func handle_sfx():
	var t = $Dialogue.text
	if t == "*Boom*":
		$Radio.stream = load("res://Assets/vine_boom.wav")
	elif t == "*Screaming*":
		$Radio.stream = load("res://Assets/screaming_girl.ogg")
	elif t == "*Cue vision*":
		$Radio.stream = load("res://Assets/vision_sound.ogg")
	else:
		return
	$Radio.play()
