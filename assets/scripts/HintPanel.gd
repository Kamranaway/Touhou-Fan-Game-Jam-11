extends MarginContainer

var hint_panel_size = 20
var left_board_size = 7

var hint = preload("res://assets/scenes/Hint.tscn")

@export var is_left := false
@onready var grid_container = $GridContainer

func update_panel_size():
	clear()
	if !is_left:
		grid_container.columns = hint_panel_size
	
	for i in range(hint_panel_size):
		for j in range(left_board_size):
			grid_container.add_child(hint.instantiate())

func set_index_str(pos_y: int, pos_x: int, new_str: String):
	var board_size = hint_panel_size if !is_left else left_board_size
	var target_index = pos_x * board_size + pos_y
	$GridContainer.get_child(target_index).set_text(new_str)
	
func set_index_visible(pos_x: int, pos_y: int, is_visible: bool):
	var board_size = hint_panel_size if !is_left else left_board_size
	var target_index = pos_x * board_size + pos_y
	$GridContainer.get_child(target_index).set_text_visible(is_visible)

func clear():
	for child in $GridContainer.get_children():
		child.set_text("0")
