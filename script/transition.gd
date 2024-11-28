extends CanvasLayer

func change_scene(target: String, type: String) -> void:
	if type == "fade_black":
		fade_black_transition(target)
	elif type == "cloud":
		cloud_transition(target)

func fade_black_transition(target: String) -> void:
	AudioManager.pause_music()
	$AnimationPlayer.play("fade to black")
	$AudioStreamPlayer.play()
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play("fade from black")
	$AudioStreamPlayer.play()

func cloud_transition(target: String) -> void:
	$AnimationPlayer.play("cloud_animation_in")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play("cloud_animation_out")
