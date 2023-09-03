extends Node

class_name LevelBase

var current_state = LevelState.INIT 
var current_brush = BrushMenu.Brush.FILL
@onready var puzzle = $Puzzle
@onready var brush_menu = $BrushMenu
@onready var timer = $Timer

enum LevelState {
	INIT, #Initialization phase
	GAMEPLAY, #Gameplay phase
}


func _ready():
	start_gameplay()


func start_gameplay():
	Events.transition_in()
	current_state = LevelState.GAMEPLAY


func _on_brush_menu_brush_updated(new_brush):
	current_brush = new_brush
	puzzle.tiles.current_brush = new_brush
	
