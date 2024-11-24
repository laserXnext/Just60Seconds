extends Node

@onready var submit: Button = $ColorRect/login
@onready var Username: LineEdit = $loginform/username
@onready var Password: LineEdit = $loginform/password
@onready var message: Label = $npc/MessageBox/message
@onready var message_box: Sprite2D = $npc/MessageBox

const GAME: PackedScene = preload("res://scene/game.tscn")

func _ready() -> void:
	Username.connect("text_changed", Callable(self, "_on_text_changed"))

func _on_submit_pressed() -> void:
	if Username.text != "":
		Global.username = Username.text
		Global.password = Password.text
		Global.roundNo = 1
		get_tree().change_scene_to_packed(GAME)
	else:
		animate_message_box()
		message.text = "Ribbit! No username? What am I supposed to call you ‘Mystery Frog’? Try again, hop to it!"

func _on_close_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_timer_timeout() -> void:
	animate_message_box()
	message.text = "Ribbit... Still typing? At this rate, I could grow legs and learn to type myself!"

func _on_text_changed(new_text: String) -> void:
	animate_message_box()

func animate_message_box() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(message_box, "scale", Vector2(0.6, 0.6), 0.3)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(message_box, "scale", Vector2(0.527, 0.51), 0.3)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN)
