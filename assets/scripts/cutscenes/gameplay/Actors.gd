extends Node

class_name Actors

var _actor_list = []

const ACTOR_DIRECTORY = "res://assets/scenes/cutscenes/actors/"


func _ready():
	var dir = DirAccess.open(ACTOR_DIRECTORY)
	var files = dir.get_files()
	
	for file in files:
		_actor_list.append(file)
		assert(file.ends_with(".tscn"), file.get_basename() + " is not a scene")
	
	assert(len(_actor_list) > 0, "No actors found \n Please add an actor to " + dir.get_current_dir())


func get_actor(actor_name):
	for actor in StageController.Actors.get_children():
		if actor.actor_name == actor_name:
			return actor
	assert(false, "Failed to get actor " + actor_name)


func add_actor(actor_name):
	for actor_file in _actor_list:
		if actor_file.get_basename() == actor_name:
			StageController.Actors.add_child(load(ACTOR_DIRECTORY + actor_file).instantiate())
			return
	assert(false, "Actor " + actor_name + " not found")


func does_actor_exist(actor_name) -> bool:
	for actor_file in _actor_list:
		if actor_file.get_basename() == actor_name:
			return true
	return false

