extends Area2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

const BULLET_COUNT = 5
const SPREAD_ANGLE = 0.2

func _physics_process(delta: float) -> void:
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range.front()
		look_at(target_enemy.global_position)

func shoot():
	const FIREBALL = preload("res://scene/fire.tscn")
	var base_rotation = %shootingPoint.global_rotation

	for i in range(BULLET_COUNT):
		var new_fireball = FIREBALL.instantiate()
		var angle_offset = (i - (BULLET_COUNT - 1) / 2) * SPREAD_ANGLE
		new_fireball.global_position = %shootingPoint.global_position
		new_fireball.global_rotation = base_rotation + angle_offset
		%shootingPoint.add_child(new_fireball)
		audio_stream_player.play()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		shoot()
