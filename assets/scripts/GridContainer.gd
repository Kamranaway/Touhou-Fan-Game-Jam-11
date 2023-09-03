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
	var coord_list = []
	
	var col_runs = get_col_runs(board_state)
	#print(col_runs)
	
	var row_runs = get_row_runs(board_state)
	#print(row_runs)
	
func get_col_runs(board_state):
	var col_runs = []
	for c in range(size_x):
		var runs = []
		var curr = 0
		var empty = true
		for r in range(size_y):
			if empty:
				if board_state[r][c] == Slot.State.FILLED:
					runs.append(curr)
					empty = false
					curr = 1
				else:
					curr = curr + 1 if board_state[r][c] == Slot.State.EMPTY else curr
			else:
				if board_state[r][c] == Slot.State.FILLED:
					curr += 1
				else:
					runs.append(curr)
					empty = true
					curr = 1 if board_state[r][c] == Slot.State.EMPTY else 0
		runs.append(curr)
		col_runs.append(runs)
	return col_runs
	
func get_row_runs(board_state):
	var row_runs = []
	for r in range(size_y):
		var runs = []
		var curr = 0
		var empty = true
		for c in range(size_x):
			if empty:
				if board_state[r][c] == Slot.State.FILLED:
					runs.append(curr)
					empty = false
					curr = 1
				else:
					curr = curr + 1 if board_state[r][c] == Slot.State.EMPTY else curr
			else:
				if board_state[r][c] == Slot.State.FILLED:
					curr += 1
				else:
					runs.append(curr)
					empty = true
					curr = 1 if board_state[r][c] == Slot.State.EMPTY else 0
		runs.append(curr)
		row_runs.append(runs)
	return row_runs

	
# takes a Vector2[]	of (x, y) coord pairs
func hide_hints_at_coords(coord_list):
	pass
				
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
