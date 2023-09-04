extends Control

class_name  BrushMenu
@export var button_group : ButtonGroup

var current_brush = Brush.FILL
signal brush_updated

enum Brush {
	FILL,
	EMPTY,
	CROSS
}


func _on_empty_button_down():
	current_brush = Brush.EMPTY
	emit_signal("brush_updated", current_brush)

func _process(_delta):
	if Input.is_action_pressed("place_fill"):
		$VBoxContainer/MarginContainer/HBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/TextureButton.button_pressed = true
	else:
		$VBoxContainer/MarginContainer/HBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/TextureButton.button_pressed = false
	
	if Input.is_action_pressed("place_cross"):
		$VBoxContainer/MarginContainer/HBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/TextureButton2.button_pressed = true
	else:
		$VBoxContainer/MarginContainer/HBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/TextureButton2.button_pressed = false
