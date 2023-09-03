extends Event

class_name WaitEvent

var _seconds : float


func _init(duration := 0.0):
	_seconds = duration
	super()


func start() -> Signal:
	await StageController.get_tree().create_timer(_seconds).timeout
	return super()
