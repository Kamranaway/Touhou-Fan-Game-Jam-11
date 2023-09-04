extends Node

const SAVE_DIRECTORY = "user://"
const SAVE_BASENAME = "SaveSlot_"
const SAVE_EXTENSION = ".save"
const STAGE_DIRECTORY = "res://assets/scenes/stages/"

func create_save(index):
	var save_data = FileAccess.open(SAVE_DIRECTORY + SAVE_BASENAME + str(index) + SAVE_EXTENSION, FileAccess.WRITE)
	var data_string = JSON.stringify(null)
	
	save_data.close()
	
func load_save(index):
	if FileAccess.file_exists(SAVE_DIRECTORY + SAVE_BASENAME + str(index) + SAVE_EXTENSION):
		var file_bytes = FileAccess.get_file_as_bytes(SAVE_DIRECTORY + SAVE_BASENAME + str(index) + SAVE_EXTENSION)

		var string_data = file_bytes
		string_data = string_data.get_string_from_ascii()
		
		var state_meta_data = JSON.parse_string(string_data)

func delete_save(index):
	DirAccess.remove_absolute(SAVE_DIRECTORY + SAVE_BASENAME + str(index) + SAVE_EXTENSION)
