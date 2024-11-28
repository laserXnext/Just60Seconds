extends Control

@onready var warning: TextureRect = $warning
@onready var label: Label = $warning/Label
@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.start(3)
	label.text = "warning !"
	animate_warning_box()
	

func _on_timer_timeout() -> void:
	label.text = "Dulneth is Coming"
	animate_warning_box()


func animate_warning_box() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(warning, "scale", Vector2(1.1, 1.1), 0.3)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(warning, "scale", Vector2(1, 1), 0.3)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN)
