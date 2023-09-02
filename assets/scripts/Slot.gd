extends MarginContainer

var current_state = State.EMPTY
@onready var cross = $Cross
@onready var fill = $Fill

enum State {
	EMPTY,
	FILLED,
	CROSS
}

func set_state(new_state: State):
	current_state = new_state
	
	match (new_state):
		State.EMPTY:
			cross.visible = false
			fill.visible = false
		State.FILLED:
			cross.visible = true
			fill.visible = true
		State.CROSS:
			cross.visible = true
			fill.visible = false
		_:
			current_state = State.EMPTY
			cross.visible = false
			fill.visible = false
