extends Control

signal solved 

@onready var tiles = $Grid/VBoxContainer/VFlowContainer/GridContainer/GridContainer
@onready var top_hint = $Grid/VBoxContainer/TopHintPanel
@onready var left_hint = $Grid/VBoxContainer/VFlowContainer/LeftHintPanel


func _on_grid_container_solved():
	emit_signal('solved')
