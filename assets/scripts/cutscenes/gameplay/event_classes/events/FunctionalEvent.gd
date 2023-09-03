extends Event

class_name FunctionalEvent

var callable


func _init(callable: Callable):
	self.callable = callable
	self.on_load = callable
	super()


func start() -> Signal:
	await callable.call()
	return super()
