extends Event
"""
Event.gd is the base class for all Events. Please
inherit Event.gd. 

Instantiating an event can be done using the new() function.
"""
class_name SimultaneousEvent

var event_one
var event_two


func _init(event_one: Event, event_two: Event):
	self.event_one = event_one
	self.event_two = event_two
	super()


func start() -> Signal:
	event_one.event.call()
	event_two.event.call()
	await event_one.event_complete
	await event_two.event_complete
	return super()
