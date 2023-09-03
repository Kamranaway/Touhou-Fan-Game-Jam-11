@tool
extends  Node

class_name StageBase

signal stage_script_loaded

func _ready():
	StageController.stage_name = self.get_script().get_path().get_basename().get_file()
	stage_script()
	emit_signal("stage_script_loaded")
	print("Stage Loaded: " + StageController.stage_name)

func stage_script():
	pass


