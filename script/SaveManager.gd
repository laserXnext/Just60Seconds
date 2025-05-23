extends Node

var roundNo = Global.roundNo
var userName = Global.username
var password = Global.password
var save_directory: String = "C:/Users/LENOVO/Documents/noidea/saves/"
var save_path: String = save_directory + userName + "_data.json"

func _process(delta: float) -> void:
	_save()

func _save():
	var data := {
		"username": userName,
		"password": password,
		"round_number": roundNo
	}

	var json_string := JSON.stringify(data)
	var file_access := FileAccess.open(save_path, FileAccess.WRITE)
	
	var dir := DirAccess.open(save_directory)
	if dir == null:
		dir = DirAccess.open("res://")  
		if dir.make_dir_recursive(save_directory) != OK:
			print("Failed to create save directory.")
			return
	
	if not file_access:
		print("An error happened while saving data: ", FileAccess.get_open_error())
		return
	file_access.store_line(json_string)
	file_access.close()
