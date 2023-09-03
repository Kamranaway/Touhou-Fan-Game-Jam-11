extends TextureRect

var _background_list = []
const BACKGROUND_DIRECTORY = "res://assets/sprites/backgrounds/"
var bg_name = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	var dir = DirAccess.open(BACKGROUND_DIRECTORY)
	var files = dir.get_files()
	
	for file in files:
		if file.ends_with(".png") or file.ends_with(".jpg") or file.ends_with(".PNG") or file.ends_with(".JPG"):
			_background_list.append(file)
		#assert(file.ends_with(".png") or file.ends_with("jpg"), file.get_basename() + file.get_extension() + " is not an accepted image format")
	
	assert(len(_background_list) > 0, "No backgrounds found \n Please add a background to " + dir.get_current_dir())

func load_background(name):
	for background_file in _background_list:
		if background_file.get_basename() == name:
			self.texture = load(BACKGROUND_DIRECTORY + background_file)
			bg_name = name
			return
	assert(false, "Background " + name + " not found")
