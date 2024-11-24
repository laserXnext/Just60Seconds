extends Area2D

@export var speed = 400.0
@export var range = 800.0

var travelled_distance = 0.0
var direction = Vector2.RIGHT 

func _ready() -> void:
	direction = Vector2.RIGHT.rotated(rotation)

func _physics_process(delta: float) -> void:
	
	position += direction * speed * delta
	travelled_distance += speed * delta

	if travelled_distance > range:
		queue_free()

func _on_body_entered(body: Node) -> void:
	queue_free()
   
	if body.has_method("take_damage"):
		body.take_damage()
