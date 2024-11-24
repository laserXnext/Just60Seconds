extends Area2D

@onready var player = get_node("/root/game/player")
@onready var attack_range: Area2D = $"attack-range"
@onready var attack_timer: Timer = $"attack-timer"
@onready var animation: AnimatedSprite2D = $"../animation"
@onready var shoot_point = $"Marker2D/orb/shoot-point"

const BULLET_COUNT = 8
const SPREAD_ANGLE = 0.2

var is_attacking = false

func _physics_process(delta: float) -> void:
	var players_in_range = get_overlapping_bodies()
	if player in players_in_range:
		aim_at_player()
		if not is_attacking:
			start_attack()
	else:
		stop_attack()

func aim_at_player() -> void:
	look_at(player.global_position)

func start_attack() -> void:
	is_attacking = true
	animation.play("attack")
	attack_timer.start()

func stop_attack() -> void:
	is_attacking = false
	animation.play("idle")
	attack_timer.stop()
	
func shoot():
	const ICEBALL = preload("res://scene/ice_bullet.tscn")
	var base_rotation = shoot_point.global_rotation
	for i in range(BULLET_COUNT):
		var new_iceball = ICEBALL.instantiate()
		var angle_offset = (i - (BULLET_COUNT - 1) / 2) * SPREAD_ANGLE
		new_iceball.global_position = shoot_point.to_global(Vector2(0, 0))
		new_iceball.rotation = base_rotation + angle_offset 
		get_tree().root.add_child(new_iceball)
	
	animation.play("attack")

func _on_timer_timeout() -> void:
	shoot()
