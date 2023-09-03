extends Control

class_name Dialog

@onready var ActorName = $DialogRig/ActorName
@onready var DialogText = $DialogRig/MarginContainer/DialogMargin/DialogText
@onready var PointerAnimation = $DialogRig/MarginContainer/DialogMargin/Pointer/PointerAnimation
@onready var Pointer = $DialogRig/MarginContainer/DialogMargin/Pointer
@onready var DialogRig = $DialogRig
@onready var TextSoundPlayer = $TextSoundPlayer
@onready var DialogConfig = $DialogConfig

@export var _dialog_tween_duration := 1.0
@export var _fast_foward_velocity := 100 #characters per second
@export var _velocity := 15 #characters per second

#Line length limit in pixels
@onready var _length_limit_px = ($DialogRig/MarginContainer.size.x - 
$DialogRig/MarginContainer/DialogMargin.size.x - DialogText.size.x)
@onready var _characters_visible := 0.0

var _line_queue = []
var _last_char_count = 0
var _tween

var history : String = ""

signal dialog_complete


func _ready():
	_tween = get_tree().create_tween()
	_tween.stop()
	

func _process(_delta):
	if _tween.is_running():
		return
	
	var delta_visible = (_fast_foward_velocity * _delta if
		Input.is_action_pressed("next_dialog") else _velocity * _delta)
		
	_characters_visible += delta_visible
	_characters_visible = clampf(_characters_visible, 0.0, DialogText.get_total_character_count())
	DialogText.set("visible_characters", _characters_visible)
	
	if(int(_characters_visible) > _last_char_count and len(DialogText.text) > 0):
		TextSoundPlayer.play()
	
	if (_characters_visible >= DialogText.get_total_character_count() and DialogText.get_total_character_count() > 0):
		PointerAnimation.play("PointerAnimation")
		Pointer.visible = true
		if (Input.is_action_just_pressed("next_dialog")):
			_next_in_queue()
	else:
		PointerAnimation.stop()
		Pointer.visible = false
	
	_last_char_count = int(_characters_visible)


#Queue lines for a single actor
func queue_lines(text):
	if ActorName.text != "":
		history += ActorName.text + ": "
	history += text + "\n"
	print(history)
	
	DialogRig.position.y = get_viewport_rect().size.y
	await _box_up()
	_line_queue.clear()
	_line_queue = _break_into_lines(text) 
	_next_in_queue()


func _box_down():
	DialogText.text = ""
	_tween = get_tree().create_tween()
	_tween.tween_property(DialogRig, "position:y", get_viewport_rect().size.y, 
		_dialog_tween_duration).set_trans(Tween.TRANS_LINEAR)
	await _tween.finished
	emit_signal("dialog_complete")


func _box_up():
	_tween = get_tree().create_tween()
	_tween.tween_property(DialogRig, "position:y", 0, 
		_dialog_tween_duration).set_trans(Tween.TRANS_LINEAR)
	await _tween.finished


func _next_in_queue():
	_characters_visible = 0
	DialogText.set("visible_characters", _characters_visible)
	
	if len(_line_queue) <= 0:
		_box_down()
		return
		
	DialogText.text = ""
	
	var content_height = DialogText.get_theme_font("normal_font").get_string_size(_line_queue[0], 
		HORIZONTAL_ALIGNMENT_LEFT, -1, DialogText.get_theme_font_size("normal_font_size")).y
		
	var box_height = ($DialogRig/MarginContainer.size.y - 
	$DialogRig/MarginContainer/DialogMargin.size.y - DialogText.size.y)
	
	var line_count = int(box_height/content_height)
	line_count = abs(line_count)
	
	if (len(_line_queue) < line_count):
		while (len(_line_queue) > 0):
			DialogText.text += _line_queue.pop_front()
			DialogText.text += "\n"
	
	for _i in range(line_count):
		if len(_line_queue) <= 0:
			break
		DialogText.text += _line_queue.pop_front()
		DialogText.text += "\n"
	pass


func _break_into_lines(text):
	var lines = []
	
	var current_line := ""
	var index := 0
	
	while len(text) > 0:
		current_line = text.left(index)
		
		var current_length_px = DialogText.get_theme_font("normal_font").get_string_size(current_line, 
		HORIZONTAL_ALIGNMENT_LEFT, -1, DialogText.get_theme_font_size("normal_font_size")).x
		
		if current_length_px > _length_limit_px:
			var _to_strip 
			
			while (text[index - 1] != ' '):
				index -= 1
				
			current_line = text.left(index)
			
			_to_strip = -(len(current_line) - 1)
			text = text.right(_to_strip)
			lines.append(current_line.left(-1))
			index = 0
			current_line = ""
		elif index == len(text):
			lines.append(current_line)
			text = ""
		
		index += 1
	return lines

func get_config_from_actor(actor: Actor):
	assert(actor != null, "Actor does not exist")
	ActorName.text = actor.actor_name if actor.actor_name != "Narrator" else ""
	DialogConfig.theme_color = actor.theme_color
	DialogConfig.font_color = actor.font_color
	DialogConfig.dialog_font = actor.dialog_font
	DialogConfig.actor_name_font = actor.actor_name_font

func _on_dialog_rig_sort_children():
	DialogRig.position.y = get_viewport_rect().size.y


func _on_dialog_rig_pre_sort_children():
	DialogRig.position.y = get_viewport_rect().size.y


func _on_sort_children():
	DialogRig.position.y = get_viewport_rect().size.y
