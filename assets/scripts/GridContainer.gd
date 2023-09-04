extends GridContainer

signal update_margin

signal solved

const MAX_HINTS = 7

var cursor_pos = Vector2.ZERO

var size_x
var size_y
@onready var slot = preload("res://assets/scenes/Slot.tscn")
@onready var cursor = get_parent().get_node("Cursor")
var current_brush = BrushMenu.Brush.EMPTY
var entry_method = EntryMethod.KEYBOARD

enum EntryMethod {
	KEYBOARD,
	KEYMOUSE
}

var last_mouse_pos = Vector2.ZERO
var lock_x = false
var lock_x_pos = 0
var lock_y = false
var lock_y_pos = 0
var mouse_inside = false
var solution
	
func _ready():
	#start_game(solution)
	pass

func start_game(_solution):
	solution = _solution
	size_x = _solution[0].size()
	size_y = _solution.size()
	for panel in get_tree().get_nodes_in_group("hint_panel"):
		panel.update_panel_size(solution)
	
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
	current_brush = BrushMenu.Brush.FILL

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
	if Input.is_action_just_pressed("swap_input_method_debug"):
		match (entry_method):
			EntryMethod.KEYBOARD:
				entry_method = EntryMethod.KEYMOUSE
				print('swapped to keymouse')
			EntryMethod.KEYMOUSE:
				entry_method = EntryMethod.KEYBOARD
				print('swapped to keyboard')
	
	match (entry_method):
		EntryMethod.KEYBOARD:
			if Input.is_action_just_pressed("place_fill"):
				var tile = get_grid_tile(cursor_pos.x, cursor_pos.y)
				#tile.set_state(tile.State.FILLED)
				if tile.change_state(tile.State.FILLED):
					check_board()
			
			if Input.is_action_just_pressed("place_cross"):
				var tile = get_grid_tile(cursor_pos.x, cursor_pos.y)
				#tile.set_state(tile.State.CROSS)
				if tile.change_state(tile.State.CROSS):
					check_board()
			
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
		EntryMethod.KEYMOUSE:
			if Input.is_action_pressed("place_fill"):
				current_brush = BrushMenu.Brush.FILL
				#print('using fill brush')
			elif Input.is_action_pressed("place_cross"):
				current_brush = BrushMenu.Brush.CROSS
				#print('using cross brush')
			else:
				current_brush = BrushMenu.Brush.EMPTY
				#print('using empty brush')

func check_board():
	var board_state = get_board_state()
	var solved = true
	for r in range(solution.size()):
		for c in range(solution[0].size()):
			if (board_state[r][c] == 1 && solution[r][c] != 1) || (board_state[r][c] != 1 && solution[r][c] == 1):
				solved = false
				break
	if !solved:
		update_hint_panels(board_state)
	else:
		print('puzzle solved')
		emit_signal('solved')
	

func update_hint_panels(board_state):
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
	var col_coord_list = []
	var row_coord_list = []
	
	# begging, PLEADING with you to never look at the internals
	# of these functions. just don't.
	var col_runs = get_col_runs(board_state)
	var row_runs = get_row_runs(board_state)
	
	# columns 
	for c in range(size_x):
		var hint_size = col_hints[c].size() # used a lot so make it a var
		# purely empty column
		if col_hints[c].size() == 0:
			continue
		if col_runs[c].size() == 1:
			print('empty col! @c = ' + str(c))
			# ... AND we were expecting a pure empty column
			if col_hints[c][0] == 0:
				col_coord_list.append(Vector2(c, MAX_HINTS-1))
			# otherwise just continue
			continue
		print('nonzzempty col! @c = ' + str(c))
		var prior_flag = false
		# iterate forwards 
		for i in range(min(hint_size, col_runs[c].size()/2)):
			# does the ith group match the ith hint? trust me on the indexing
			if col_hints[c][i] == col_runs[c][i*2 + 1]:
				# is there only one group AND one hint? easy guarantee
				if (hint_size == 1 && col_runs[c].size()/2 == 1):
					prior_flag = true
					col_coord_list.append(Vector2(c, MAX_HINTS - hint_size + i))
				# are we currently considering a match for the final hint?
				# if so there's no way for us to be mismatching with a next hint
				elif i + 1 == hint_size:
					# if prior_flag is set, we know there can be no unknown hints
					# before or after what we're currently considering, so it's
					# guaranteed valid at this point. if not, still vague
					if prior_flag:
						col_coord_list.append(Vector2(c, MAX_HINTS - hint_size + i))
					continue
				# otherwise, we must consider if group i could actually be matching with hint i+1;
				# this is only possible IFF hint i+1 is not smaller than hint i (and thus group i),
				# AND hint i could feasibly fit in the space LEFT/ABOVE group i (runs[c][i*2])
				elif (col_hints[c][i] > col_hints[c][i+1] 
					|| !check_if_fits(col_runs[c][i*2], col_hints[c][i])):
					#print('this one :)')
					prior_flag = true
					col_coord_list.append(Vector2(c, MAX_HINTS - hint_size + i))
				# otherwise we are too vague, give up
				else:
					prior_flag = false
		# iterate backwards
		var last_group_index = (col_runs[c].size() / 2) * 2 - 1 # GUARANTEES an odd number
		for i in range(min(hint_size, col_runs[c].size()/2)):
			if col_hints[c][hint_size - 1 - i] == col_runs[c][last_group_index - (i*2)]:
				if i + 1 == hint_size:
					if prior_flag:
						col_coord_list.append(Vector2(c, MAX_HINTS - 1 - i))
					continue
				elif (col_hints[c][hint_size - i - 1] > col_hints[c][hint_size - i - 2] 
					|| !check_if_fits(col_runs[c][last_group_index - (i*2) + 1], col_hints[c][hint_size - i - 1])):
					prior_flag = true
					col_coord_list.append(Vector2(c, MAX_HINTS - 1 - i))
				else:
					prior_flag = false
					
	# rows 
	for r in range(size_y):
		var hint_size = row_hints[r].size()
		if row_hints[r].size() == 0:
			continue
		if row_runs[r].size() == 1:
			print('empty row! @r = ' + str(r))
			if row_hints[r][0] == 0:
				row_coord_list.append(Vector2(MAX_HINTS - 1, r))
			continue
		print('nonempty row! @r = ' + str(r))
		var prior_flag = false
		for i in range(min(hint_size, row_runs[r].size()/2)):
			if row_hints[r][i] == row_runs[r][i*2 + 1]:
				if (hint_size == 1 && row_runs[r].size()/2 == 1):
					prior_flag = true
					row_coord_list.append(Vector2(MAX_HINTS - hint_size + i, r))
				elif i + 1 == hint_size:
					if prior_flag:
						row_coord_list.append(Vector2(MAX_HINTS - hint_size + i, r))
					continue
				elif (row_hints[r][i] > row_hints[r][i+1] 
					|| !check_if_fits(row_runs[r][i*2], row_hints[r][i])):
					prior_flag = true
					row_coord_list.append(Vector2(MAX_HINTS - hint_size + i, r))
				else:
					prior_flag = false
		# iterate backwards
		var last_group_index = (row_runs[r].size() / 2) * 2 - 1
		for i in range(min(hint_size, row_runs[r].size()/2)):
			if row_hints[r][hint_size - 1 - i] == row_runs[r][last_group_index - (i*2)]:
				if i + 1 == hint_size:
					if prior_flag:
						row_coord_list.append(Vector2(MAX_HINTS - 1 - i, r))
					continue
				elif (row_hints[r][hint_size - i - 1] > row_hints[r][hint_size - i - 2] 
					|| !check_if_fits(row_runs[r][last_group_index - (i*2) + 1], row_hints[r][hint_size - i - 1])):
					prior_flag = true
					row_coord_list.append(Vector2(MAX_HINTS - 1 - i, r))
				else:
					prior_flag = false
	
	hide_hints_at_coords(col_coord_list, row_coord_list)

func check_if_fits(spaces, size):
	#print(spaces)
	# spaces starts with EMPTY spaces. odd nums are ignored
	for i in range(0, spaces.size(), 2):
		#print(spaces[i])
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
			runs.append([0])
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
			runs.append([0]) # necessary to avoid crashing against walls later sowwy
		else: 
			non_fill_runs.append(curr)
			#print(non_fill_runs)
			runs.append(non_fill_runs)
		row_runs.append(runs)
	return row_runs

# takes a Vector2[]	of (x, y) coord pairs
func hide_hints_at_coords(col_coord_list, row_coord_list):
	var need_ungrey = true
	for panel in get_tree().get_nodes_in_group("hint_panel"):
		if true:
			panel.ungrey_all()
			need_ungrey = false
		if !panel.is_left:
			for idx in range(col_coord_list.size()):
				panel.set_index_grey(col_coord_list[idx].x, col_coord_list[idx].y, true)
				#print('x: ' + str(col_coord_list[idx].x) + ' y: ' + str(col_coord_list[idx].y))
		else:
			for idx in range(row_coord_list.size()):
				panel.set_index_grey(row_coord_list[idx].x, row_coord_list[idx].y, true)
				#print('x: ' + str(row_coord_list[idx].x) + ' y: ' + str(row_coord_list[idx].y))

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
