

# member variables include solution, hints, cursor position, board state
var board_width
var board_height
var cursor = Vector2(0,0)
var entry_state = EntryState.NONE
var board_state
#var col_hints
#var row_hints
var entry_method = EntryMethod.KEY

enum EntryState {NONE, MARK, CROSS}
enum EntryMethod {KEY, KEYMOUSE}

func _ready():
	board_state = generate_matrix(20,20)


func generate_matrix(width, height):
	var a = []
	a.resize(width)
	a.fill(0)
	var matrix = []
	matrix.resize(height)
	matrix.fill(a)
	return matrix

func _input(event):
	pass

func _physics_process(delta):
	pass

# have to set up some stuff in godot for this
func _process(delta):
	if Input.is_action_just_pressed("press_x"):
		if entry_method == EntryMethod.KEY:
			write_square(EntryState.MARK, cursor.x, cursor.y)
	if Input.is_action_just_pressed("press_z"):
		if entry_method == EntryMethod.KEY:
			write_square(EntryState.CROSS, cursor.x, cursor.y)

func write_square(to_enter, x, y):
	pass 
	#if 

