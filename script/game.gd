extends Node2D

@onready var player: CharacterBody2D = $player
@onready var spawn_timer: Timer = $SpawnTimer
@onready var round_no: Label = $"Player-Ui/round/TextureRect/CanvasGroup/roundNo"
@onready var escape_menu: Control = $"Player-Ui/escape/escapeMenu"
@onready var death: AnimatedSprite2D = $DeathScreen/youdead/death
@onready var game_timer: Timer = $"Player-Ui/countdown/gameTimer"

var mobs = []
var roundNo = Global.roundNo
var userName = Global.username
var password = Global.password
var paused = false


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("back"):
		pauseMenu()

func pauseMenu():
	if paused:
		escape_menu.hide()
		Engine.time_scale = 1
	else :
		escape_menu.show()
		Engine.time_scale = 0
	
	paused = !paused

func _ready() -> void:
	AudioManager.pause_music()
	round_no.text = str(roundNo)
	spawn()
	wraith_spawn()
	zombie_spawn()

func zombie_spawn():
	var new_zombie = preload("res://scene/zombie.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_zombie.global_position = %PathFollow2D.global_position
	add_child(new_zombie)
	mobs.append(new_zombie)

func wraith_spawn():
	var wraith = preload("res://scene/skeleton.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	wraith.global_position = %PathFollow2D.global_position
	add_child(wraith)
	mobs.append(wraith)

func spawn():
	var new_mob = preload("res://scene/mob.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)
	mobs.append(new_mob)

func mobDespawn():
	for mob in mobs:
		if mob and is_instance_valid(mob):
			mob.queue_free()
	mobs.clear()  # Clear the mob list after removal
	spawn_timer.stop()


func gandalfspawn():
	var gandalf = preload("res://scene/gandalf.tscn").instantiate()
	gandalf.global_position = get_viewport_rect().size / 2
	const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
	var smoke = SMOKE_SCENE.instantiate()
	get_parent().add_child(smoke)
	smoke.global_position = get_viewport_rect().size / 2
	add_child(gandalf)
	
	mobDespawn()

func _on_timer_timeout() -> void:
	zombie_spawn()
	spawn()

func _on_player_health_ranout() -> void:
	%youdead.visible = true
	mobDespawn()
	game_timer.stop()

func _on_game_timer_timeout() -> void:
	gandalfspawn()


func _on_restart_pressed() -> void:
	Global.roundNo = roundNo 
	get_tree().reload_current_scene()  
	%youdead.visible = false
	game_timer.start()

func _on_home_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
	%youdead.visible = false
	AudioManager.resume_music()
	Engine.time_scale = 1
