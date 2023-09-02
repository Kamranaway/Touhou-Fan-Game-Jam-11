extends GridContainer

@export var size_x := 20
@export var size_y := 20

@onready var slot = preload("res://assets/scenes/Slot.tscn")

signal update_margin


# Called when the node enters the scene tree for the first time.
func _ready():
	for panel in get_tree().get_nodes_in_group("hint_panel"):
		if !panel.is_left:
			panel.hint_panel_size = size_x
		else:
			panel.hint_panel_size = size_y
		panel.update_panel_size()
	
	self.columns = size_x
	
	get_parent().custom_minimum_size.x = 40 * size_x
	get_parent().custom_minimum_size.y = 40 * size_y
	custom_minimum_size.x = 40 * size_x
	custom_minimum_size.y = 40 * size_y
	
	
	for i in range(size_x):
		for j in range(size_y):
			var new_slot = slot.instantiate()
			self.add_child(slot.instantiate())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

