extends Node

class_name LevelBase

var current_state = LevelState.INIT 
var current_brush = BrushMenu.Brush.FILL
@onready var puzzle = $Puzzle
@onready var brush_menu = $BrushMenu
@onready var timer = $Timer
@onready var game_board = $Puzzle/Grid/VBoxContainer/VFlowContainer/GridContainer/GridContainer
@onready var puzzle_data = $PuzzleData

enum LevelState {
	INIT, #Initialization phase
	GAMEPLAY, #Gameplay phase
}

var solution

func _ready():
	start_gameplay()


func start_gameplay():
	solution = puzzle_data.TEST_PUZZLE
	Events.transition_in()
	current_state = LevelState.GAMEPLAY
	game_board.start_game(puzzle_data.TEST_PUZZLE)
	#call_deferred('game_board_start')

func _on_brush_menu_brush_updated(new_brush):
	current_brush = new_brush
	puzzle.tiles.current_brush = new_brush

func _on_puzzle_solved():
	print('somehow, magically, we did it')
	var time = timer.stop_timer()
	
