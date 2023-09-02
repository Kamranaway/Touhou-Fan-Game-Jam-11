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


func _on_fill_button_down():
	current_brush = Brush.FILL
	emit_signal("brush_updated", current_brush)

func _on_cross_button_down():
	current_brush = Brush.CROSS
	emit_signal("brush_updated", current_brush)
