extends CharacterBody2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var speech_sound = preload("res://assets/sound_effect/text.mp3")


const lines: Array[String] = [
	"Ribbit! You've made it this far, traveler.",
	"To pass to the next round,",
	"you must answer my question."
	]

const next_scene: PackedScene = preload("res://scene/scroll.tscn")

func _ready() -> void:
	interaction_area.interact = Callable(self,"_on_interact")
	sprite.play("idle")
	
func _on_interact():
	sprite.play("talk")
	DialogManager.start_dialog(global_position, lines, speech_sound)
	sprite.flip_h = true if interaction_area.get_overlapping_bodies()[0].global_position.x < global_position.x else false
	await DialogManager.dialog_finished
	open_next_scene()

func open_next_scene():
	var new_scene = next_scene.instantiate()
	get_tree().change_scene_to_packed(next_scene)
	AudioManager.resume_music()
