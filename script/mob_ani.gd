extends Node

func play_walk():
	$AnimationPlayer.play("walk")

func play_hurt():
	$AnimationPlayer.play("hurt")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "hurt":
		play_walk()
