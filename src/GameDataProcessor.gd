class_name GameDataProcessor

var InstructionSet = load("res://src/InstructionSet.gd")

var rooms
var currentRoom = null
var inventory = {}

func _init():
	rooms = loadJsonData("res://data/game1.json")

# Load the game data from the json file.
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

func process_action(action, object = null):
	# React to the help command.
	if action == InstructionSet.HELP:
		var helpText = ''
		helpText += 'Instructions:' + "\n"
		helpText += '- Use "look" around the room you are in.' + "\n"
		helpText += '- Use "north", "south", "east", "west" to move in that direction.' + "\n"
		helpText += '- Use "open" or "close" to interact with doors.' + "\n"
		helpText += '- Use "get <object" or "drop <object" pick up or put down objects.' + "\n"
		helpText += '- Use "reset" to reset the game, or "exit" to quit.' + "\n"
		return helpText

	# React to the reset command.
	if action == InstructionSet.RESET:
		currentRoom = null
		inventory = {}
		rooms = loadJsonData("res://data/game1.json")
		return process_action(null)

	# React to the quit command.
	if action == InstructionSet.QUIT:
		Engine.get_main_loop().quit()
		return 'Bye...'

	# If the current room is empty then start with the initial room.
	if currentRoom == null:
		currentRoom = 'room1'
		return render_room(rooms[currentRoom])

	# React to the look command.
	if action == InstructionSet.LOOK:
		return render_room(rooms[currentRoom])

	if action == InstructionSet.GET and object != null:
		for item in rooms[currentRoom]['items']:
			if rooms[currentRoom]['items'][item]['name'] == object:
				inventory[item] = rooms[currentRoom]['items'][item]
				return 'You get the ' + object;
		return 'There is no ' + object + "\n"

	if action == InstructionSet.OPEN and object != null:
		var direction = object.get_slice(' ', 0)
		var exit = object.get_slice(' ', 1)
		for item in rooms[currentRoom]['exits']:
			if item == direction:
				for inventoryItem in inventory:
					if rooms[currentRoom]['exits'][item]['key'] == inventoryItem:
						rooms[currentRoom]['exits'][item]['locked'] = false
						return 'You open the ' + direction + ' door'
			else:
				return 'What direction do you want to open?'
		return 'You do not have the key for this door'

	# If we get to this point we have a direction of some kind.
	# Is direction/action valid?
	if rooms[currentRoom]['exits'].has(action) == false:
		return 'I don\'t understand!' + "\n"

	# is a direction then change the state to the new room.
	if rooms[currentRoom]['exits'][action].has('destination') == true:
		if rooms[currentRoom]['exits'][action].has('locked') and rooms[currentRoom]['exits'][action]['locked'] == true:
			return "The door is locked!\n"
		currentRoom = rooms[currentRoom]['exits'][action]['destination']

	# return the text of the new room
	return render_room(rooms[currentRoom])

# Render a given room, including the exits.
func render_room(room):
	var renderedRoom = ''
	renderedRoom += room['intro'] + "\n"

	if room.has('items') == true:
		for item in room['items']:
			if inventory.has(item) == false:
				renderedRoom += room['items'][item]['description'] + "\n"

	renderedRoom += "\nPossible exists are:\n"

	for exit in room['exits']:
		renderedRoom += "- " + room['exits'][exit]['description'] + "\n"
	return renderedRoom
