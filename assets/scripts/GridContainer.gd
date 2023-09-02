extends GridContainer

var cursor_pos = Vector2.ZERO

@export var size_x := 20
@export var size_y := 20
@onready var slot = preload("res://assets/scenes/Slot.tscn")
@onready var cursor = get_parent().get_node("Cursor")

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
			self.add_child(slot.instantiate())

func grid_to_index(x: int, y: int):
	return (y * size_x) + x

func get_grid_tile(x: int, y: int):
	return get_child(grid_to_index(x, y))

func update_cursor_sprite_position():
	cursor.position = get_grid_tile(cursor_pos.x, cursor_pos.y).position
	cursor.position.x += 20
	cursor.position.y += 20

func get_inputs():
	if Input.is_action_just_pressed("ui_right"):
		cursor_pos.x += 1
	elif Input.is_action_just_pressed("ui_left"):
		cursor_pos.x -= 1
		
	if Input.is_action_just_pressed("ui_up"):
		cursor_pos.y -= 1
	if Input.is_action_just_pressed("ui_down"):
		cursor_pos.y += 1
	
	cursor_pos.x = clampi(cursor_pos.x, 0, size_x - 1)
	cursor_pos.y = clampi(cursor_pos.y, 0, size_y - 1)
	update_cursor_sprite_position()

func _process(delta):
	get_inputs()
