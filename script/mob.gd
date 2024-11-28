extends CharacterBody2D

@onready var player = get_node("/root/game/player")
@onready var health_bar: ProgressBar = $healthBar

var difficulty = int(Global.roundNo)
var health 

func _ready() -> void:
	health = 3 * difficulty
	health_bar.init_health(health)
	%Slime.play_walk()

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * (180.0 + difficulty * 10.0)
	move_and_slide()
	
func take_damage():
	health -= difficulty
	%Slime.play_hurt()
	health_bar.health = health
	if health == 0:
		queue_free()
		Global.slimeCount += 1
		const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
