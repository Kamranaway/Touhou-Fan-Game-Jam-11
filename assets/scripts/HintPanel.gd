extends MarginContainer

var side_length
const MAX_HINTS = 7

var hint = preload("res://assets/scenes/Hint.tscn")

@export var is_left := false
@onready var grid_container = $GridContainer

#being called by another node's _ready
func update_panel_size(solution):
	clear()
	side_length = solution[0].size() if !is_left else solution.size()
	#print(str(side_length) + ' for is_left = ' + str(is_left))
	grid_container.columns = side_length if !is_left else MAX_HINTS
	for i in range(side_length * MAX_HINTS):
		grid_container.add_child(hint.instantiate())
	col_hints = generate_col_hints(solution)
	row_hints = generate_row_hints(solution)
	write_hints()
	
func set_index_edge(pos_x: int, pos_y: int, is_vertical: bool):
	print('is_vertical: ' + str(is_vertical) + ' pos_x: ' + str(pos_x) + ' pos_y: ' + str(pos_y))
	var row_size = side_length if !is_left else MAX_HINTS
	var target_index = pos_y * row_size + pos_x
	$GridContainer.get_child(target_index).set_edge(is_vertical)

func set_index_str(pos_x: int, pos_y: int, new_str: String):
	var row_size = side_length if !is_left else MAX_HINTS
	var target_index = pos_y * row_size + pos_x
	$GridContainer.get_child(target_index).set_text(new_str)
	
func set_index_visible(pos_x: int, pos_y: int, is_visible: bool):
	var row_size = side_length if !is_left else MAX_HINTS
	var target_index = pos_y * row_size + pos_x
	$GridContainer.get_child(target_index).set_text_visible(is_visible)
	
func set_index_grey(pos_x: int, pos_y: int, is_grey: bool):
	var row_size = side_length if !is_left else MAX_HINTS
	var target_index = pos_y * row_size + pos_x
	$GridContainer.get_child(target_index).grey_out(is_grey)
	
func ungrey_all():
	for child in $GridContainer.get_children():
		child.grey_out(false)

func clear():
	for child in $GridContainer.get_children():
		child.set_text("0")

var col_hints
var row_hints
	

func write_hints():
	if !is_left: 
		#print(col_hints)
		for col in range(col_hints.size()):
			set_index_edge(col, MAX_HINTS - col_hints[col].size(), true)
			for i in range(col_hints[col].size()):
				#print(str(col) + ", " + str(i + (MAX_HINTS - col_hints[col].size())))
				set_index_str(col, i + (MAX_HINTS - col_hints[col].size()), str(col_hints[col][i]))
					
	else:
		#print(row_hints)
		for row in range(row_hints.size()):
			set_index_edge(MAX_HINTS - row_hints[row].size(), row, false)
			for i in range(row_hints[row].size()):
				set_index_str(i + (MAX_HINTS - row_hints[row].size()), row, str(row_hints[row][i]))
					
		#for row in range(row_hints.size()):
			#for i in range(7):
				#set_index_str(i, row, str(i))
	
	

func generate_col_hints(sol):
	var hints = []
	hints.resize(sol[0].size()) # num of columns
	for c in range(hints.size()):
		var nums = []
		var run_cnt = 0
		for r in range(sol.size()): # cols above, number of rows here. important swap
			if(sol[r][c] == 0 && run_cnt == 0):
				continue
			if(sol[r][c] == 0 && run_cnt != 0):
				nums.append(run_cnt)
				run_cnt = 0
				continue
			run_cnt += 1
		if run_cnt != 0:
			nums.append(run_cnt)
		hints[c] = nums
	return hints

func generate_row_hints(sol):
	var hints = []
	hints.resize(sol.size()) # num of columns
	for r in range(hints.size()):
		var nums = []
		var run_cnt = 0
		for c in range(sol[0].size()): # rows above, number of cols here. important swap
			if(sol[r][c] == 0 && run_cnt == 0):
				continue
			if(sol[r][c] == 0 && run_cnt != 0):
				nums.append(run_cnt)
				run_cnt = 0
				continue
			run_cnt += 1
		if run_cnt != 0:
			nums.append(run_cnt)
		hints[r] = nums
	return hints
