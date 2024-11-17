extends Control

@onready var newGame: Button = $new
@onready var loadGame: Button = $load
@onready var confirmation_panel: Panel = $confirmationPanel

const PROFILE: PackedScene = preload("res://scene/profile.tscn")
const LOAD: PackedScene = preload("res://scene/load_menu.tscn")

func _ready() -> void:
	PROFILE.connect("pressed", Callable(self, "_on_new_pressed"))
	LOAD.connect("pressed", Callable(self, "_on_load_pressed"))

func _on_new_pressed() -> void:
	get_tree().change_scene_to_packed(PROFILE)

func _on_load_pressed() -> void:
	get_tree().change_scene_to_packed(LOAD)

func _on_quit_pressed() -> void:
	confirmation_panel.visible = true

func _on_confirm_pressed() -> void:
	get_tree().quit()

func _on_cancel_pressed() -> void:
	confirmation_panel.visible = false
