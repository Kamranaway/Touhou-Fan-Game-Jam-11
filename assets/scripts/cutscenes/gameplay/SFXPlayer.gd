extends AudioStreamPlayer

"""

SFX Player contains a list of all SFX that can be played by the given instance of the player.

"""

@export var sfx_list: Array[AudioStream] = []


func start_sfx(index):
	stream = sfx_list[index]
	play()
