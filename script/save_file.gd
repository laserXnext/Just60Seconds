extends Control

@onready var confirmation_dialog: ConfirmationDialog = $ConfirmationDialog
@onready var password_entry: LineEdit = $PasswordConfirmation/passArea/password_entry
@onready var username: Label = $Panel/username
@onready var round_no: Label = $Panel/roundNo
@onready var error_message: Label = $PasswordConfirmation/passArea/error
@onready var attempt_message: Label = $PasswordConfirmation/passArea/attempt
@onready var slime: Label = $"stat/stat-screen/slime"
@onready var zombie: Label = $"stat/stat-screen/zombie"
@onready var wraith: Label = $"stat/stat-screen/wraith"
@onready var health_label: Label = $"stat/stat-screen/VBox/player/playerStat/healthLabel"
@onready var speed_label: Label = $"stat/stat-screen/VBox/player/playerStat/speedLabel"

var stored_password: String = ""
var attempt : int = 0

const SAVE_DIRECTORY = "C:/Users/LENOVO/Documents/noidea/saves/"
const GAME : PackedScene = preload("res://scene/game.tscn")
const SEC_KEY = Global.THE_KEY

func _ready() -> void:
	load_save_data()
	health_label.text = "Health : " + str(Global.player_health)
	speed_label.text = "Speed  : " + str(Global.player_velocity)
	confirmation_dialog.connect("confirmed", Callable(self, "_on_confirm_delete"))
	

func load_save_data() -> void:
	var file_path: String = SAVE_DIRECTORY + username.text + "_data.json"
	var file := FileAccess.open_encrypted_with_pass(file_path, FileAccess.READ, SEC_KEY)
	if file:
		var json = JSON.new()
		var error_code = json.parse(file.get_as_text())
		if error_code == OK:
			var save_data = json.get_data()
			if save_data.has("password") and save_data["password"] != null:
				stored_password = str(save_data["password"])
			else:
				print("Password not found in save data.")
		else:
			print("Failed to parse JSON: Error Code", error_code)
		file.close()
	else:
		print("Save file not found.")


func _on_play_pressed() -> void:
	if stored_password != "":
		%passArea.visible = true
	else:
		Global.username = username.text
		Global.roundNo = round_no.text
		Global.slimeCount = int(slime.text)
		Global.zombieCount = int(zombie.text)
		Global.wraithCount = int(wraith.text)
		get_tree().change_scene_to_packed(GAME)


func _on_delete_pressed() -> void:
	confirmation_dialog.set_text("Are you sure you want to delete this save?")
	confirmation_dialog.popup_centered()


func delete_save_file(file_path: String) -> void:
	if FileAccess.file_exists(file_path):
		var dir := DirAccess.open(SAVE_DIRECTORY)
		if dir:
			if dir.remove_absolute(file_path) == OK:
				print("File deleted successfully!")
			else:
				print("Failed to delete file.")
		else:
			print("Could not open directory.")
	else:
		print("File not found:", file_path)


func _on_confirmation_dialog_confirmed() -> void:
	var file_path: String = SAVE_DIRECTORY + username.text + "_data.json"
	delete_save_file(file_path)
	get_tree().reload_current_scene()


func _on_confirm_button_pressed() -> void:
	if stored_password == password_entry.text:
		Global.username = username.text
		Global.roundNo = round_no.text
		Global.slimeCount = int(slime.text)
		Global.zombieCount = int(zombie.text)
		Global.wraithCount = int(wraith.text)
		get_tree().change_scene_to_packed(GAME)
	elif password_entry.text != stored_password:
		error_message.text = "Incorrect password. Please try again."
		attempt += 1
		attempt_message.text = "Attempt - " + str(attempt)
		if attempt > 3:
			get_tree().reload_current_scene()


func _on_cancel_button_pressed() -> void:
	%passArea.visible = false


func _on_stat_pressed() -> void:
	$"stat/stat-screen".visible = true


func _on_button_pressed() -> void:
	$"stat/stat-screen".visible = false
