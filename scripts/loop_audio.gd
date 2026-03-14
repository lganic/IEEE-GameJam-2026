extends AudioStreamPlayer2D

func _ready():
	finished.connect(play)
