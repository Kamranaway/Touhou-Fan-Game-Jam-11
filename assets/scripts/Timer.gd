extends Control

var time_elapsed = 0
@onready var timeLabel = $MarginContainer/HBoxContainer/Label

var stopped = false

func _process(delta):
	if stopped:
		return
	var time_msec = Time.get_ticks_msec()
	time_elapsed = time_msec / 1000.0
	
	var seconds = time_msec / 1000
	
	var hours = seconds / (60 * 60)
	seconds -= hours * 60 * 60
	
	var minutes = seconds / 60
	seconds -= minutes * 60

	timeLabel.text = str(hours).pad_zeros(2) + ":" + str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)
	
func stop_timer():
	stopped = true
	return time_elapsed
