extends Node

signal transition_complete

@onready var animation = $AnimationPlayer

func _ready():
	animation.play("RESET")

func start(reverse: bool = false):
	animation.play("RESET")
	
	if reverse:
		animation.play_backwards("dissolve")
	else:
		animation.play("dissolve")
	
	await animation.animation_finished
	
	emit_signal("transition_complete")
