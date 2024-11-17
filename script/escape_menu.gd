extends Control

@onready var game = $"../../.."

const MAIN : PackedScene = preload("res://main_menu.tscn")
var save = preload("res://script/SaveManager.gd").new()


func _ready() -> void:
	MAIN.connect("pressed", Callable(self, "_on_texture_button_pressed"))

func _on_resume_pressed() -> void:
	game.pauseMenu()

func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
	Engine.time_scale = 1
	AudioManager.resume_music()

func _on_close_pressed() -> void:
	game.pauseMenu()

func _on_save_pressed() -> void:
	save._save()
