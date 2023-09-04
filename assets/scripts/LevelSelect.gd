extends Control

@onready var one = $CenterContainer/VBoxContainer/HBoxContainer/MarginContainer/one
@onready var two = $CenterContainer/VBoxContainer/HBoxContainer2/MarginContainer2/two
@onready var three = $CenterContainer/VBoxContainer/HBoxContainer3/MarginContainer3/three
@onready var four = $CenterContainer/VBoxContainer/HBoxContainer4/MarginContainer4/four


func _on_one_button_down():
	get_tree().change_scene_to_file("res://assets/scenes/levels/Level1.tscn")


func _on_two_button_down():
	get_tree().change_scene_to_file("res://assets/scenes/levels/Level3.tscn")

func _on_three_button_down():
	get_tree().change_scene_to_file("res://assets/scenes/levels/Level6.tscn")


func _on_four_button_down():
	get_tree().change_scene_to_file("res://assets/scenes/levels/Level9.tscn")
