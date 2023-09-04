extends MarginContainer

class_name Slot

var current_state = State.EMPTY
@onready var cross = $Cross
@onready var fill = $Fill

signal on_click

enum State {
	EMPTY = 0,
	FILLED = 1,
	CROSS = -1
}

# completely ignores previous state, not to be used for player actions
func set_state(new_state: State):
	current_state = new_state
	toggle_visibility()
	
func change_state(state_to_try: State):
	if state_to_try == State.EMPTY:
		return false # do nothing if we're not actually intending to change it (i.e. mouseover with no option selected
	if current_state != State.EMPTY:
		current_state = State.EMPTY
	else:	
		current_state = state_to_try
	toggle_visibility()
	return true
	
func toggle_visibility():
	match(current_state):
		State.EMPTY:
			cross.visible = false
			fill.visible = false
		State.FILLED:
			cross.visible = false
			fill.visible = true
		State.CROSS:
			cross.visible = true
			fill.visible = false
		_:
			print('what the fuck')

func _on_mouse_entered():
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		match (get_parent().current_brush):
			BrushMenu.Brush.FILL:
				change_state(State.FILLED)
				get_parent().check_board()
			BrushMenu.Brush.EMPTY:
				change_state(State.EMPTY)
			BrushMenu.Brush.CROSS:
				change_state(State.CROSS)
				get_parent().check_board()

func _on_texture_button_button_down():
	match (get_parent().current_brush):
			BrushMenu.Brush.FILL:
				change_state(State.FILLED)
				get_parent().check_board()
			BrushMenu.Brush.EMPTY:
				change_state(State.EMPTY)
			BrushMenu.Brush.CROSS:
				change_state(State.CROSS)
				get_parent().check_board()
	emit_signal("on_click", Vector2(global_position.x + 20, global_position.y + 20))
