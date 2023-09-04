extends AudioStreamPlayer

"""

Music Player is responsible for all music in the game.
Music Player is a global node that persists between scenes.
It also contains a list of all tracks available in the game.

"""

@export var track_list: Array[AudioStream] = []
var song_name = ""


func start_track(index):
	stream = track_list[index]
	track_list[index]
	play()

func stop_track():
	stop()
	song_name = ""
