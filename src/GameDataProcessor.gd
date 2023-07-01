class_name GameDataProcessor

var InstructionSet = load("res://src/InstructionSet.gd")

var rooms
var currentRoom = null
var instructionSet

func _init():
	rooms = loadJsonData("res://data/game1.json")
	instructionSet = InstructionSet.new()

func loadJsonData(fileName):
	var file = FileAccess.open(fileName, FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()

	var json = JSON.new()
	var error = json.parse(json_string)
	if error == OK:
		var data_received = json.data
		if typeof(data_received) == TYPE_DICTIONARY:
			return data_received
		else:
			assert(false, "Unexpected data in JSON output")
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		assert(false, "JSON Parse Error")

func process_action(action):
	if action == instructionSet.HELP:
		var helpText = ''
		helpText += 'Look: Look around the room you are in.' + "\n"
		helpText += 'Use north, south, east, west to more in that direction.' + "\n"
		return helpText

	if action == instructionSet.RESET:
		currentRoom = null
		return process_action(null)

	# get current room
	if currentRoom == null:
		currentRoom = 'room1'
		return render_room(rooms[currentRoom])

	if action == instructionSet.LOOK:
		return render_room(rooms[currentRoom])

	# is direction/action valid?
	if rooms[currentRoom]['exits'].has(action) == false:
		return 'direction not valid!' + "\n"

	# if it is then change the state
	if rooms[currentRoom]['exits'][action].has('destination') == true:
		currentRoom = rooms[currentRoom]['exits'][action]['destination']

	# return the text of the new room
	return render_room(rooms[currentRoom])

func render_room(room):
	var renderedRoom = ''
	renderedRoom += room['intro'] + "\n\n"
	renderedRoom += "Possible exists are:\n"
	for exit in room['exits']:
		renderedRoom += "- " + room['exits'][exit]['description'] + "\n"
	return renderedRoom
