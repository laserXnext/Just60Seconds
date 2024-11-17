extends Node

@onready var knight: AnimatedSprite2D = $"../../knight"


func play_idle_animation():
	$AnimationPlayer.play("idle")

func play_walk_animation():
	$AnimationPlayer.play("walk")

func play_man_idle():
	knight.play("man_idle")
	
func play_man_run():
	knight.play("man_run")
