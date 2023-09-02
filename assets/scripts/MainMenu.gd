extends Control

@onready var settings = $Settings

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_down():
	get_tree().change_scene_to_file("res://assets/scenes/Levels/LevelBase.tscn")


func _on_settings_button_down():
	settings.visible = true


func _on_quit_button_down():
	get_tree().quit()


func _on_tutorial_button_down():
	pass # Replace with function body.


func _on_credits_button_down():
	pass # Replace with function body.
