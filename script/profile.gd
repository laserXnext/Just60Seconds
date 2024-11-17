extends Node

@onready var submit: Button = $ColorRect/login
@onready var Username: LineEdit = $loginform/username
@onready var Password: LineEdit = $loginform/password

const GAME: PackedScene = preload("res://scene/game.tscn")
#const MAIN : PackedScene = preload("res://main_menu.tscn")


func _ready() -> void:
	#MAIN.connect("pressed", Callable(self, "_on_texture_button_pressed"))
	GAME.connect("pressed", Callable(self, "_on_submit_pressed"))

func _on_submit_pressed() -> void:
	Global.username = Username.text
	Global.password = Password.text
	Global.roundNo = 1
	get_tree().change_scene_to_packed(GAME)
	

func _on_close_button_pressed() -> void:
		get_tree().change_scene_to_file("res://main_menu.tscn")
