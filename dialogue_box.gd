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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not visible:
		return
	if reading == true and Input.is_action_just_released("enter"):
		idx += 2
		if idx == len(dialogue):
			reading = false
			visible = false
		else:
			label.text = dialogue[idx]
			speaker.text = dialogue[idx-1]
