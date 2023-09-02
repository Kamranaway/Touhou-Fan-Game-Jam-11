extends Button

@export var binding_action = ""

func _unhandled_input(event):
	if event is InputEventKey:
		if text == "...":
			InputMap.action_erase_events(binding_action)
			InputMap.action_add_event(binding_action, event)
			text = event.as_text()
