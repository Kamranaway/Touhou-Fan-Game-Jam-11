extends PopupPanel

@onready var sfx_label = $VBoxContainer/VBoxContainer/GridContainer2/SfxLabel
@onready var music_label = $VBoxContainer/VBoxContainer2/GridContainer/MusicLabel

var sfx_volume = 100
var music_volume = 100

func _on_sfx_value_changed(value):
	sfx_label.text = str(value)
	sfx_volume = value


func _on_music_value_changed(value):
	music_label.text = str(value)
	music_volume = value
