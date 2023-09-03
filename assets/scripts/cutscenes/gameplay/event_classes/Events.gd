class_name Events


static func load_background(name):
	var callable = (func(name): 
		StageController.Background.load_background(name)
		).bind(name)
	FunctionalEvent.new(callable)

static func dialog(actor_name: String, text: String):
	DialogEvent.new(actor_name, text)

static func narrate(text:String):
	DialogEvent.new("Narrator", text)
	
static func wait(duration:float):
	WaitEvent.new(duration)


static func start_track(index):
	var callable = func(index): MusicPlayer.start_track(index).bind(index)
	FunctionalEvent.new(callable)


static func stop_track():
	var callable = func(): MusicPlayer.stop()
	FunctionalEvent.new(callable)


static func start_sfx(index):
	var callable = func(index): StageController.SFX_Player.start_sfx(index).bind(index)
	FunctionalEvent.new(callable)


static func stop_sfx():
	var callable = func(): StageController.stop()
	FunctionalEvent.new(callable)

static func transition_out():
	var callable = (func(): 
		StageController.Transition.transition_out()
		await StageController.Transition.transition_complete
		)
	FunctionalEvent.new(callable)
	

static func transition_in():
	var callable = (func(): 
		StageController.Transition.transition_in()
		await await StageController.Transition.transition_complete
		)
	FunctionalEvent.new(callable)

static func load_stage(stage_name: String):
	var callable = (func(stage_name):
		StageController.load_stage(stage_name)
		).bind(stage_name)
	
	FunctionalEvent.new(callable)

static func change_scene(scene_name: String):
	var callable = (func(stage_name):
		StageController.change_scene(scene_name)
		).bind(scene_name)
	
	FunctionalEvent.new(callable)


static func add_actor(name):
	var callable = (func(name): StageController.Actors.add_actor(name)).bind(name)
	FunctionalEvent.new(callable)


static func add_doll_part(actor_name, index):
	var callable = (func(actor_name, index): StageController.Actors.get_actor(actor_name
		).add_doll_part(index)).bind(actor_name, index)
	FunctionalEvent.new(callable)


static func clear_doll_parts(actor_name):
	var callable = (func(actor_name): StageController.Actors.get_actor(actor_name).clear_doll_parts(
		)).bind(actor_name)
	FunctionalEvent.new(callable)


static func interp_position(actor_name, new_pos: Vector2, delay = 1.0, trans_type: 
	Tween.TransitionType = Tween.TRANS_LINEAR, ease_type: Tween.EaseType = Tween.EASE_IN_OUT):
	
	var callable = (func(actor_name, new_pos, delay, trans_type, ease_type): 
		await StageController.Actors.get_actor(actor_name).interpolate_position(new_pos, delay, 
		trans_type, ease_type)).bind(actor_name, new_pos, delay, trans_type, ease_type)
	FunctionalEvent.new(callable)


static func set_position(actor_name, new_pos: Vector2):
	var callable = (func(actor_name, new_pos): StageController.Actors.get_actor(actor_name).set_position(new_pos)).bind(actor_name, new_pos)
	FunctionalEvent.new(callable)


static func set_pose(actor_name, index):
	var callable = (func(actor_name, index):  StageController.Actors.get_actor(actor_name).set_pose(index).bind(actor_name, index))
	FunctionalEvent.new(callable)
	

