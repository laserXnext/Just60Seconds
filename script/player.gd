extends CharacterBody2D
class_name player

signal health_ranout

var health = 100.0

func _physics_process(delta: float) -> void:
	if DialogManager.is_dialog_active:
		return
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * 300
	move_and_slide()
	
	#player direction
	if direction.x < 0:
		%player_ani.knight.flip_h = true
	elif direction.x > 0:
		%player_ani.knight.flip_h = false
	
	#player animation
	if velocity.length() > 0.0:
		%player_ani.play_man_run()
	else:
		%player_ani.play_man_idle()
	
	const DamageRate = 15.0
	var overlapping_mobs = %HitBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		health -= DamageRate * overlapping_mobs.size() * delta
		%healthbar.value = health
		if health <= 0.0:
			health_ranout.emit()
	
	var screen_size = get_viewport_rect().size
	if position.x < 0:
		position.x = screen_size.x
	elif position.x > screen_size.x:
		position.x = 0

	if position.y < 0:
		position.y = screen_size.y
	elif position.y > screen_size.y:
		position.y = 0
