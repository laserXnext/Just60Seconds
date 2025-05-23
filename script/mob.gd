extends CharacterBody2D

@onready var player = get_node("/root/game/player")

var difficulty = int(Global.roundNo)

var health = 3 * difficulty

func _ready() -> void:
	%Slime.play_walk()

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * (180.0 + difficulty * 10.0)
	move_and_slide()
	
func take_damage():
	health -= difficulty
	%Slime.play_hurt()
	
	if health == 0:
		queue_free()
		const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
