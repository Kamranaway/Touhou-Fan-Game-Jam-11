extends PopupPanel

@onready var master_label = $VBoxContainer/VBoxContainer3/GridContainer2/MasterLabel
@onready var sfx_label = $VBoxContainer/VBoxContainer/GridContainer2/SfxLabel
@onready var music_label = $VBoxContainer/VBoxContainer2/GridContainer/MusicLabel

@onready var down_button = $VBoxContainer/MarginContainer/VBoxContainer/GridContainer/down
@onready var up_button = $VBoxContainer/MarginContainer/VBoxContainer/GridContainer/up
@onready var left_button = $VBoxContainer/MarginContainer/VBoxContainer/GridContainer/left
@onready var right_button = $VBoxContainer/MarginContainer/VBoxContainer/GridContainer/right

var binding_action = ""

func _on_sfx_value_changed(value):
	sfx_label.text = str(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sfx"), linear_to_db(value))



func _on_music_value_changed(value):
	music_label.text = str(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))


func _on_master_value_changed(value):
	master_label.text = str(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))


func _on_up_button_down():
	up_button.text = "..."


func _on_down_button_down():
	down_button.text = "..."


func _on_left_button_down():
	left_button.text = "..."


func _on_right_button_down():
	right_button.text = "..."


