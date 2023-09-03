extends GridContainer

var cursor_pos = Vector2.ZERO

@export var size_x := 20
@export var size_y := 20
@onready var slot = preload("res://assets/scenes/Slot.tscn")
@onready var cursor = get_parent().get_node("Cursor")
var current_brush = BrushMenu.Brush.FILL

var last_mouse_pos = Vector2.ZERO

var lock_x = false
var lock_x_pos = 0
var lock_y = false
var lock_y_pos = 0

var mouse_inside = false

signal update_margin

# Called when the node enters the scene tree for the first time.
func _ready():
	for panel in get_tree().get_nodes_in_group("hint_panel"):
		if !panel.is_left:
			panel.hint_panel_size = size_x
		else:
			panel.hint_panel_size = size_y
		panel.update_panel_size()
	
	self.columns = size_x
	
	get_parent().custom_minimum_size.x = 40 * size_x
	get_parent().custom_minimum_size.y = 40 * size_y
	custom_minimum_size.x = 40 * size_x
	custom_minimum_size.y = 40 * size_y
	
	for i in range(size_x):
		for j in range(size_y):
			var new_slot = slot.instantiate()
			new_slot.connect("on_click", _on_slot_click)
			self.add_child(new_slot)
	lock_x = false
	lock_y = false

func grid_to_index(x: int, y: int):
	return (y * size_x) + x

func get_grid_tile(x: int, y: int):
	return get_child(grid_to_index(x, y))
	
func get_grid_tile_state(x: int, y: int):
	return get_grid_tile(x, y).current_state

func update_cursor_sprite_position():
	cursor.position = get_grid_tile(cursor_pos.x, cursor_pos.y).position
	cursor.position.x += 20
	cursor.position.y += 20

func get_inputs():
	if Input.is_action_just_pressed("place_fill"):
		var tile = get_grid_tile(cursor_pos.x, cursor_pos.y)
		#tile.set_state(tile.State.FILLED)
		if tile.change_state(tile.State.FILLED):
			update_hint_panels()
	
	if Input.is_action_just_pressed("place_cross"):
		var tile = get_grid_tile(cursor_pos.x, cursor_pos.y)
		#tile.set_state(tile.State.CROSS)
		if tile.change_state(tile.State.CROSS):
			update_hint_panels()
	
	if Input.is_action_just_pressed("cursor_right"):
		cursor_pos.x += 1
		#print(get_grid_tile_state(cursor_pos.x, cursor_pos.y))
	elif Input.is_action_just_pressed("cursor_left"):
		cursor_pos.x -= 1
		#print(get_grid_tile_state(cursor_pos.x, cursor_pos.y))
	if Input.is_action_just_pressed("cursor_up"):
		cursor_pos.y -= 1
		#print(get_grid_tile_state(cursor_pos.x, cursor_pos.y))
	if Input.is_action_just_pressed("cursor_down"):
		cursor_pos.y += 1
		#print(get_grid_tile_state(cursor_pos.x, cursor_pos.y))
	
	cursor_pos.x = clampi(cursor_pos.x, 0, size_x - 1)
	cursor_pos.y = clampi(cursor_pos.y, 0, size_y - 1)
	update_cursor_sprite_position()

func update_hint_panels():
	# get separate nodes for the top and left panels
	var hint_panel_left
	var hint_panel_top
	for hint_panel in get_tree().get_nodes_in_group("hint_panel"):
		if hint_panel.is_left:
			hint_panel_left = hint_panel
		else:
			hint_panel_top = hint_panel
	var col_hints = hint_panel_top.col_hints
	var row_hints = hint_panel_top.row_hints
	var board_state = get_board_state()
	var col_coord_list = []
	
	# begging, PLEADING with you to never look at the internals
	# of these functions. just don't.
	var col_runs = get_col_runs(board_state)
	var row_runs = get_row_runs(board_state)
	
	# columns 
	for c in range(size_x):
		var prior_flag = false
		# iterate forwards 
		for i in range(min(col_hints[c].size(), col_runs[c].size()/2)):
			if col_hints[c][i] == col_runs[c][i*2 + 1]:
				if (col_hints[c].size() == 1 && col_runs[c].size()/2 == 1):
					prior_flag = true
					col_coord_list.append(Vector2(c, 7 - col_hints[c].size() + i))
				elif i + 1 == col_hints[c].size():
					if prior_flag:
						col_coord_list.append(Vector2(c, 7 - col_hints[c].size() + i))
					continue
				elif (col_hints[c][i] > col_hints[c][i+1] 
					|| !check_if_fits(col_runs[c][i*2], col_hints[c][i])):
					#print('this one :)')
					prior_flag = true
					col_coord_list.append(Vector2(c, 7 - col_hints[c].size() + i))
				else:
					prior_flag = false
		# iterate backwards
		for i in range(min(col_hints[c].size(), col_runs[c].size()/2)-1, -1, -1):
			if col_hints[c][i] == col_runs[c][i*2 + 1]:
				if i == 0:
					if prior_flag:
						col_coord_list.append(Vector2(c, 7 - col_hints[c].size() + i))
					continue
				elif (col_hints[c][i] > col_hints[c][i-1] 
					|| !check_if_fits(col_runs[c][(i+1)*2], col_hints[c][i])):
					prior_flag = true
					col_coord_list.append(Vector2(c, 7 - col_hints[c].size() + i))
				else:
					prior_flag = false
	
	hide_hints_at_coords(col_coord_list, false)
	
func check_if_fits(spaces, size):
	print(spaces)
	# spaces starts with EMPTY spaces. odd nums are ignored
	for i in range(0, spaces.size(), 2):
		print(spaces[i])
		if spaces[i] >= size:
			return true
	return false

#ugly as fuck but i swear it's gonna be worth it later
# looks like this:
#[[spaces, (X's,...)], filled, ...] 
func get_col_runs(board_state):
	var col_runs = []
	for c in range(size_x):
		var runs = []
		var non_fill_runs = []
		var curr = 0
		var state = Slot.State.EMPTY
		for r in range(size_y):
			match(state):
				Slot.State.FILLED:
					match(board_state[r][c]):
						Slot.State.FILLED:
							curr += 1
						Slot.State.EMPTY:
							runs.append(curr)
							non_fill_runs = []
							state = Slot.State.EMPTY
							curr = 0
						Slot.State.CROSS:
							runs.append(curr)
							non_fill_runs = [0]
							state = Slot.State.CROSS
							curr = 1
				Slot.State.EMPTY:
					match(board_state[r][c]):
						Slot.State.FILLED:
							non_fill_runs.append(curr-1)
							runs.append(non_fill_runs)
							state = Slot.State.FILLED
							curr = 1
						Slot.State.EMPTY:
							curr += 1
						Slot.State.CROSS:
							non_fill_runs.append(curr)
							#print(non_fill_runs)
							state = Slot.State.CROSS
							curr = 1
				Slot.State.CROSS:
					match(board_state[r][c]):
						Slot.State.FILLED:
							non_fill_runs.append(curr)
							runs.append(non_fill_runs)
							state = Slot.State.FILLED
							curr = 1
						Slot.State.EMPTY:
							non_fill_runs.append(curr)
							#print(non_fill_runs)
							state = Slot.State.EMPTY
							curr = 1
						Slot.State.CROSS:
							curr += 1
		if state == Slot.State.FILLED:
			runs.append(curr)
		else: 
			non_fill_runs.append(curr)
			#print(non_fill_runs)
			runs.append(non_fill_runs)
		col_runs.append(runs)
	return col_runs
	
func get_row_runs(board_state):
	var row_runs = []
	for r in range(size_y):
		var runs = []
		var non_fill_runs = []
		var curr = 0
		var state = Slot.State.EMPTY
		for c in range(size_x):
			match(state):
				Slot.State.FILLED:
					match(board_state[r][c]):
						Slot.State.FILLED:
							curr += 1
						Slot.State.EMPTY:
							runs.append(curr)
							non_fill_runs = []
							state = Slot.State.EMPTY
							curr = 0
						Slot.State.CROSS:
							runs.append(curr)
							non_fill_runs = [0]
							state = Slot.State.CROSS
							curr = 1
				Slot.State.EMPTY:
					match(board_state[r][c]):
						Slot.State.FILLED:
							non_fill_runs.append(curr-1)
							runs.append(non_fill_runs)
							state = Slot.State.FILLED
							curr = 1
						Slot.State.EMPTY:
							curr += 1
						Slot.State.CROSS:
							non_fill_runs.append(curr)
							#print(non_fill_runs)
							state = Slot.State.CROSS
							curr = 1
				Slot.State.CROSS:
					match(board_state[r][c]):
						Slot.State.FILLED:
							non_fill_runs.append(curr)
							runs.append(non_fill_runs)
							state = Slot.State.FILLED
							curr = 1
						Slot.State.EMPTY:
							non_fill_runs.append(curr)
							#print(non_fill_runs)
							state = Slot.State.EMPTY
							curr = 1
						Slot.State.CROSS:
							curr += 1
		if state == Slot.State.FILLED:
			runs.append(curr)
		else: 
			non_fill_runs.append(curr)
			#print(non_fill_runs)
			runs.append(non_fill_runs)
		row_runs.append(runs)
	return row_runs

	
# takes a Vector2[]	of (x, y) coord pairs
func hide_hints_at_coords(col_coord_list, row_coord_list):
	for panel in get_tree().get_nodes_in_group("hint_panel"):
		if !panel.is_left:
			panel.ungrey_all()
			for idx in range(col_coord_list.size()):
				panel.set_index_grey(col_coord_list[idx].x, col_coord_list[idx].y, true)
				print('x: ' + str(col_coord_list[idx].x) + ' y: ' + str(col_coord_list[idx].y))
				
# strip state of the board into 2d array; saves time for multiple calls
# and makes it like 20000 times easier to code lol
func get_board_state():
	var matrix = []
	for r in range(size_y):
		matrix.append([])
		for c in range(size_x):
			matrix[r].append(Slot.State.EMPTY)
	for c in range(size_x):
		for r in range(size_y):
			matrix[r][c] = get_grid_tile_state(c, r)
	return matrix

func _process(delta):
	get_inputs()
	
	if !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		lock_x = false
		lock_y = false
	last_mouse_pos = get_global_mouse_position()


func _on_mouse_entered():
	mouse_inside = true

func _on_mouse_exited():
	mouse_inside = false

func _input(event):
	if event is InputEventMouseMotion:
		if mouse_inside and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if lock_x == false and lock_y == false:
				if event.velocity.length() > 500:
					lock_x_pos = event.global_position.x
					lock_y_pos = event.global_position.y
					if event.velocity.x * event.velocity.x > event.velocity.y * event.velocity.y:
						lock_x = true
					else:
						lock_y = true
			if lock_x:
				Input.warp_mouse(Vector2(event.global_position.x, lock_y_pos))
			elif lock_y:
				Input.warp_mouse(Vector2(lock_x_pos, event.global_position.y))

func _on_slot_click(pos: Vector2):
	if mouse_inside:
		if lock_x == false and lock_y == false:
			Input.warp_mouse(pos)
