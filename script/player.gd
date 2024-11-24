extends CharacterBody2D
class_name player

@onready var heal_timer: Timer = $heal_timer
@onready var regen: Label = $Regen
@onready var flicker_timer: Timer = $heal_timer/flickerTimer
@onready var health_bar: ProgressBar = $PlayerUi/healthBar

signal health_ranout

const DamageRate = 5.0
const MAX_HEALTH = 200.0
const REGEN_AMOUNT = 5.0

var health = MAX_HEALTH

func _ready() -> void:
	health_bar.init_health(health)
	heal_timer.start()
	flicker_timer.connect("timeout",Callable( self, "_on_flicker_timer_timeout"))
	regen.visible = false 

func _physics_process(delta: float) -> void:
	if DialogManager.is_dialog_active:
		return
	
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * 300
	move_and_slide()
	
	# Player direction
	if direction.x < 0:
		%player_ani.knight.flip_h = true
	elif direction.x > 0:
		%player_ani.knight.flip_h = false
	
	# Player animation
	if velocity.length() > 0.0:
		%player_ani.play_man_run()
	else:
		%player_ani.play_man_idle()
	
	# Damage detection
	var overlapping_mobs = %HitBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		health -= DamageRate * overlapping_mobs.size() * delta
		#%healthbar.value = health
		health_bar.health = health
		if health <= 0.0:
			health_ranout.emit()
	
	# Screen wrapping logic
	var screen_size = get_viewport_rect().size
	if position.x < 0:
		position.x = screen_size.x
	elif position.x > screen_size.x:
		position.x = 0
	if position.y < 0:
		position.y = screen_size.y
	elif position.y > screen_size.y:
		position.y = 0
	
func take_damage() -> void:
	health -= DamageRate * Global.roundNo
	#%healthbar.value = health
	health_bar.health = health
	if health <= 0.0:
		health_ranout.emit()

func _on_heal_timer_timeout() -> void:
	if health < MAX_HEALTH:
		health += REGEN_AMOUNT
		#%healthbar.value = min(health, MAX_HEALTH)
		if not flicker_timer.is_stopped():
			flicker_timer.stop()
		regen.visible = true
		flicker_timer.start(0.5)
	else:
		regen.visible = false 


func _on_flicker_timer_timeout() -> void:
	regen.visible = not regen.visible
	if health >= MAX_HEALTH:
		flicker_timer.stop()
		regen.visible = false
