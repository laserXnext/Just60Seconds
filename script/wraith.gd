extends CharacterBody2D

@onready var player = get_node("/root/game/player")
@onready var animation: AnimatedSprite2D = $animation
@onready var health_bar: ProgressBar = $uiLayer/healthBar

var difficulty = int(Global.roundNo)

var health = 200 * difficulty

func _ready() -> void:
	health_bar.init_health(health)
	animation.play("run")

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * (180.0 + difficulty * 10.0)
	animation.flip_h = direction.x < 0
	move_and_slide()
	
func take_damage():
	health -= difficulty
	health_bar.health = health
	if health == 0:
		queue_free()
		const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
