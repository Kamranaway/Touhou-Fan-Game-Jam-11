extends Event

class_name DialogEvent

var _actor_name : String
var _text
var _dialog_box: Dialog


func _init(actor_name, text):
	_actor_name = actor_name
	_text = text
	_dialog_box = StageController.DialogBox
	super()


func start() -> Signal:
	_dialog_box.get_config_from_actor(StageController.Actors.get_actor(_actor_name))
	_dialog_box.queue_lines(_text)
	print(_actor_name + ": " + _text)
	await _dialog_box.dialog_complete
	return super()
