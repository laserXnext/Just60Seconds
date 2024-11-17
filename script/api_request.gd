extends Control

@onready var http_request: HTTPRequest = $HTTPRequest
@onready var sprite: Sprite2D = $Sprite2D
@onready var buttons = $ButtonContainer.get_children()

var url = "http://marcconrad.com/uob/banana/api.php?out=json"
const next_scene: String = "res://scene/game.tscn"
var roundNo = int(Global.roundNo)
var question = ""
var solution = ""
var incorrect_answers = []

func _ready() -> void:
	# Set the button placeholders to "1"
	for button in buttons:
		(button as Button).text = "1"
		(button as Button).connect("pressed", Callable(self, "_on_answer_selected").bind("1"))
	
	http_request.request(url)

func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var json_string = body.get_string_from_utf8()
	var json = JSON.new()
	var json_data = json.parse(json_string)
	
	if json_data == OK:
		var parsed_data = json.get_data()
		question = parsed_data["question"]
		solution = str(parsed_data["solution"])
		
		print("Question: " + question)
		print("Solution: " + solution)

		var image_url = question
		download_image(image_url)
		setup_answer_buttons() # Call to set up the buttons after data is loaded
	else:
		print("Error parsing JSON")

# Function to download the image from the URL
func download_image(image_url: String) -> void:
	var image_request = HTTPRequest.new()
	add_child(image_request)
	image_request.connect("request_completed", Callable(self, "_on_image_request_completed"))
	image_request.request(image_url)

func _on_image_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var image = Image.new()
	var error = image.load_png_from_buffer(body)
	
	if error != OK:
		print("Error loading image: ", error)
	else:
		var texture = ImageTexture.create_from_image(image)
		sprite.texture = texture

# Generate three unique random wrong answers between 1 and 10
func generate_random_answers() -> Array:
	var answers = []
	while answers.size() < 3:
		var random_number = str(randi() % 10 + 1) # Random number between 1 and 10
		if random_number != solution and random_number not in answers:
			answers.append(random_number)
	return answers
	
func setup_answer_buttons() -> void:
	# Generate incorrect answers
	incorrect_answers = generate_random_answers()
	
	# Combine solution with incorrect answers
	var all_answers = []
	all_answers.append(solution)
	all_answers.append_array(incorrect_answers)
	all_answers.shuffle()

	# Assign the answers to the buttons
	for i in range(buttons.size()):
		var button = buttons[i] as Button
		button.text = all_answers[i]
		# Disconnect previous signals and connect the new answers to button press
		button.disconnect("pressed", Callable(self, "_on_answer_selected").bind("1"))
		button.connect("pressed", Callable(self, "_on_answer_selected").bind(all_answers[i]))

func _on_answer_selected(answer: String) -> void:
	if answer == solution:
		print("Correct Answer!")
		roundNo += 1
		Global.roundNo = roundNo
		open_next_scene() 
	else:
		print("Wrong Answer!")
		roundNo = 1
		Global.roundNo = roundNo
		open_next_scene()

# Function to open the next scene (game scene)
func open_next_scene() -> void:
	get_tree().change_scene_to_file(next_scene)
