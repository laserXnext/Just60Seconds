extends Node

@onready var count: Label = $count
@onready var game_timer: Timer = $gameTimer


func _ready():
	$AnimatedSprite2D.play("clock")
	game_timer.start()
	count.text = str(int(game_timer.time_left))  # Initialize the label with the starting time
	game_timer.connect("timeout", Callable(self, "_on_Timer_timeout"))

func _process(delta):
	count.text = str(int(game_timer.time_left))  # Update the countdown display with whole seconds
#
func _on_Timer_timeout():
	$AnimatedSprite2D.pause()
	queue_free()
