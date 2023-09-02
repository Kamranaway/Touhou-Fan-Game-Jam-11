extends MarginContainer

func set_text(new_str: String):
	$CenterContainer/HintLabel.text = new_str
	
	if new_str == "0":
		set_text_visible(false)
	else:
		set_text_visible(true)

func set_text_visible(is_visible: bool):
	$CenterContainer/HintLabel.visible = is_visible

func grey_out(is_grey: bool):
	if is_grey:
		self.modulate = Color.DARK_GRAY
	else:
		self.modulate = Color.WHITE

func _ready():
	grey_out(true)
