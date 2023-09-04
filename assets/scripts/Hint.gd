extends MarginContainer

func set_text(new_str: String):
	$CenterContainer/HintLabel.text = new_str
	
	if new_str == "0":
		set_text_visible(false)
	else:
		set_text_visible(true)

func set_edge(is_vertical: bool):
	pass
	#if is_vertical:
		#$VertEdge.visible = true
	#	$EdgeHint.visible = false
	#	$BlockHint.visible = false
		#$VertBlockHint.visible = false
	#else: 
		#$VertEdge.visible = false
	#	$EdgeHint.visible = true
		#$BlockHint.visible = false
	#	$VertBlockHint.visible = false

func set_text_visible(is_visible: bool):
	$CenterContainer/HintLabel.visible = is_visible
	#$BlockHint.visible = is_visible
	#$Panel.visible = is_visible
	#$EdgeHint.visible = false
	#$VertBlockHint.visible = false
	#$VertEdge.visible = false
	
	

func grey_out(is_grey: bool):
	if is_grey:
		self.modulate = Color.DARK_GRAY
	else:
		self.modulate = Color.WHITE

func _ready():
	grey_out(false)
	set_text_visible(false)
