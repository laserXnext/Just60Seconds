extends Control

#@onready var save_list_container: VBoxContainer = $Panel/SaveListContainer
@onready var save_list_container: VBoxContainer = $Panel/ScrollContainer/SaveListContainer

const SAVE_DIRECTORY = "C:/Users/LENOVO/Documents/noidea/saves/"
const SEC_KEY = Global.THE_KEY

func _ready() -> void:
	_load_saves()

func _load_saves() -> void:
	var dir := DirAccess.open(SAVE_DIRECTORY)
	if not dir:
		print("Error: Unable to access save directory.")
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name:
		if file_name.ends_with(".json"):
			_load_save_file(SAVE_DIRECTORY + file_name)
		file_name = dir.get_next()
	dir.list_dir_end()

func _load_save_file(file_path: String) -> void:
	var file_access := FileAccess.open_encrypted_with_pass(file_path, FileAccess.READ, SEC_KEY)
	if not file_access:
		print("Error opening file: ", file_path)
		return

	var json_string := file_access.get_as_text()
	file_access.close()

	var json := JSON.new()
	var error := json.parse(json_string)
	if error:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string)
		return

	var data: Dictionary = json.data
	var username = data.get("username", "noname")
	var round_number = str(data.get("round_number", 1))
	var slime = str(data.get("slime", 0))
	var zombie = str(data.get("zombie", 0))
	var wraith =  str(data.get("wraith", 0))

	# Instantiate SaveFile and set data
	var save_file_instance = load("res://scene/save_file.tscn").instantiate()
	save_file_instance.get_node("Panel/username").text = username
	save_file_instance.get_node("Panel/roundNo").text = round_number
	save_file_instance.get_node("stat/stat-screen/slime").text = slime
	save_file_instance.get_node("stat/stat-screen/zombie").text = zombie
	save_file_instance.get_node("stat/stat-screen/wraith").text = wraith
	
	# Add instance to the container
	save_list_container.add_child(save_file_instance)

func _on_close_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
