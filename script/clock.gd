extends Node

@onready var time: Label = $"time"
@onready var clock_timer: Timer = $Timer
@onready var clock_img: TextureRect = $"clock-img"

func _ready():
	clock_timer.start()
	time.text = str(int(clock_timer.time_left))
	clock_timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	animate_box()

func _process(delta):
	time.text = str(int(clock_timer.time_left))
#
func _on_Timer_timeout():
	queue_free()

func animate_box() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(clock_img, "rotation", 2 * PI, 20)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.finished.connect(animate_box)
