extends Sprite2D

class_name Actor

@export var actor_name := ""
@export var _pose_index := 0
@export var pose_list: Array[Texture] = []
@export var doll_parts_list: Array[Texture] = []
@export var y_center_offset := 0.0

@export var font_color := Color.WHITE
@export var theme_color := Color.WHITE
@export var dialog_font : Resource
@export var actor_name_font : Resource

@onready var STAGE_X_LEFT := get_viewport_rect().size.x / 4
@onready var STAGE_X_CENTER := get_viewport_rect().size.x / 2
@onready var STAGE_X_RIGHT := (get_viewport_rect().size.x / 4) * 3
@onready var STAGE_Y_CENTER := get_viewport_rect().size.y/2

enum StartingPosition {Left, Center, Right}
@export var starting_position: StartingPosition = StartingPosition.Center


func _ready():
	if len(pose_list) > 0:
		set_pose(0)
	
	match starting_position:
		StartingPosition.Left:
			position.x = STAGE_X_LEFT
			position.y = STAGE_Y_CENTER + y_center_offset
		StartingPosition.Center:
			position.x = STAGE_X_CENTER
			position.y = STAGE_Y_CENTER + y_center_offset
		StartingPosition.Right:
			position.x = STAGE_X_RIGHT
			position.y = STAGE_Y_CENTER + y_center_offset
		_:
			position.x = STAGE_X_CENTER
			position.y = STAGE_Y_CENTER + y_center_offset


func set_pose(index):
	_pose_index = index
	self.texture = pose_list[index]


func add_doll_part(index):
	var new_part = Sprite2D.new()
	new_part.texture = doll_parts_list[index]
	self.add_child(new_part)


func clear_doll_parts():
	for part in self.get_children():
		part.queue_free()


func interpolate_position(new_pos: Vector2, delay, trans_type: Tween.TransitionType, ease_type: Tween.EaseType):
	var _tween = get_tree().create_tween()
	return _tween.tween_method(set_position, position, new_pos, delay).set_trans(trans_type).set_ease(ease_type).finished


func set_actor_position(new_pos: Vector2):
	self.position = new_pos


func get_actor_data() -> Array:
	return [actor_name, _pose_index, [], position]
