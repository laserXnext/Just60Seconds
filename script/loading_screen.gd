extends Control

@export var target_scene_path : String = "res://main_menu.tscn"
@onready var progress_bar: ProgressBar = $ColorRect/ProgressBar
@onready var timer: Timer = $Timer

func _ready():
	AudioManager.pause_music()
	timer.connect("timeout",Callable(self, "_on_timer_timeout"))
	progress_bar.value = 0

func _process(delta):
	if not timer.is_stopped():
		var elapsed_time = timer.wait_time - timer.time_left
		progress_bar.value = (elapsed_time / timer.wait_time) * 100

func _on_timer_timeout():
	get_tree().change_scene_to_file(target_scene_path)
	AudioManager.resume_music()
