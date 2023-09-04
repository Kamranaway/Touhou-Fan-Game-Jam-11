extends MarginContainer

func set_text(new_str: String):
	$CenterContainer/HintLabel.text = new_str
	
	if new_str == "0":
		set_text_visible(false)
	else:
		set_text_visible(true)

func set_edge(is_vertical: bool):
	if is_vertical:
		pass
		# set it to the vertical edge texture
	else: 
		pass
		# horiz. edge texture

func set_text_visible(is_visible: bool):
	$CenterContainer/HintLabel.visible = is_visible
	$TextureRect.visible = is_visible

func grey_out(is_grey: bool):
	if is_grey:
		self.modulate = Color.DARK_GRAY
	else:
		self.modulate = Color.WHITE

func _ready():
	grey_out(false)
	set_text_visible(false)
