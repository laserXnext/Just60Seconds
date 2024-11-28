extends CharacterBody2D

@onready var zombie_anime: AnimatedSprite2D = $zombieAnime
@onready var player = get_node("/root/game/player")
@onready var attack_box: Area2D = $Area2D
@onready var health_bar: ProgressBar = $healthBar

var difficulty = int(Global.roundNo)
var health = 10 * difficulty
var is_attacking = false

func _ready() -> void:
	health_bar.init_health(health)
	zombie_anime.play("run")

func _physics_process(delta: float) -> void:
	if not is_attacking:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * (150.0 + difficulty * 10.0)
		move_and_slide()
		zombie_anime.flip_h = direction.x < 0

	# Check for collisions with the player's hitbox
	var overlapping_bodies = attack_box.get_overlapping_bodies()
	if player in overlapping_bodies:
		if not is_attacking:
			is_attacking = true
			zombie_anime.play("attack")
			await attack_player()
	else:
		is_attacking = false
		if zombie_anime.animation != "run":
			zombie_anime.play("run")

func attack_player() -> void:
	player.health -= 10.0 * difficulty
	if player.health <= 0:
		player.emit_signal("health_ranout")
	await zombie_anime.animation_finished
	is_attacking = false
	zombie_anime.play("run")

func take_damage() -> void:
	health -= 2.5 * difficulty
	health_bar.health = health
	zombie_anime.play("hurt")
	
	if health == 0:
		queue_free()
		Global.zombieCount += 1
		const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
