extends Node

class_name LevelBase

var current_state = LevelState.INIT 
var current_brush = BrushMenu.Brush.FILL
@onready var game_board = $Puzzle/Grid/VBoxContainer/VFlowContainer/GridContainer/GridContainer
@onready var puzzle = $Puzzle
@onready var brush_menu = $BrushMenu
@onready var timer = $Timer

enum LevelState {
	INIT, #Initialization phase
	GAMEPLAY, #Gameplay phase
}

#TESTING PURPOSES; DELETE LATER!!!
const TEST_PUZZLE = [
	[1 ,0 ,0 ,1 ,0 ,0 ,0 ,1 ,0 ,0 ,1 ,0 ,1 ,0 ,0],
	[1 ,0 ,0 ,1 ,0 ,0 ,0 ,1 ,0 ,0 ,1 ,0 ,1 ,0 ,0],
	[1 ,0 ,0 ,1 ,0 ,0 ,0 ,1 ,0 ,0 ,1 ,0 ,1 ,0 ,0],
	[1 ,0 ,0 ,1 ,0 ,0 ,0 ,1 ,0 ,0 ,1 ,0 ,1 ,0 ,0],
	[1 ,0 ,0 ,0 ,1 ,0 ,0 ,1 ,0 ,0 ,0 ,1 ,0 ,1 ,0],
	[1 ,0 ,0 ,0 ,1 ,0 ,0 ,0 ,1 ,0 ,0 ,1 ,0 ,1 ,0],
	[1 ,0 ,0 ,0 ,1 ,0 ,0 ,0 ,1 ,0 ,0 ,1 ,0 ,1 ,0],
	[1 ,0 ,0 ,0 ,1 ,0 ,0 ,0 ,1 ,0 ,0 ,1 ,0 ,0 ,1],
	[1 ,0 ,0 ,0 ,1 ,0 ,0 ,0 ,1 ,1 ,0 ,0 ,1 ,0 ,1],
	[1 ,0 ,0 ,0 ,0 ,1 ,0 ,0 ,1 ,1 ,0 ,0 ,1 ,1 ,1],
	[1 ,1 ,1 ,1 ,0 ,1 ,0 ,1 ,1 ,1 ,1 ,1 ,0 ,0 ,0],
	[1 ,0 ,0 ,0 ,1 ,1 ,1 ,0 ,1 ,1 ,1 ,0 ,0 ,0 ,0],
	[1 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,1 ,1 ,1 ,0 ,0 ,0 ,0],
	[1 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,1 ,1 ,1 ,0 ,0 ,0 ,0],
	[0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0]]

var solution = TEST_PUZZLE

func _ready():
	start_gameplay()


func start_gameplay():
	Events.transition_in()
	current_state = LevelState.GAMEPLAY
	#call_deferred('game_board_start')

#func game_board_start():
	#game_board.
	#game_board.start_game(solution)

func _on_brush_menu_brush_updated(new_brush):
	current_brush = new_brush
	puzzle.tiles.current_brush = new_brush

func _on_puzzle_solved():
	print('somehow, magically, we did it')
	var time = timer.stop_timer()
	
