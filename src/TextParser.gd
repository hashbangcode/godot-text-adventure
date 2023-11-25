class_name TextParser

var InstructionSet = load("res://src/InstructionSet.gd")

var object = null

# Parse a given input string into an instruction.
func parse(text):
	match text:
		'go north':
			return InstructionSet.NORTH
		'north':
			return InstructionSet.NORTH
		'go south':
			return InstructionSet.SOUTH
		'south':
			return InstructionSet.SOUTH
		'go east':
			return InstructionSet.EAST
		'east':
			return InstructionSet.EAST
		'go west':
			return InstructionSet.WEST
		'west':
			return InstructionSet.WEST

		'look':
			return InstructionSet.LOOK
		'help':
			return InstructionSet.HELP
		'help me':
			return InstructionSet.HELP

		'reset':
			return InstructionSet.RESET
		'quit':
			return InstructionSet.QUIT
		'exit':
			return InstructionSet.QUIT

	if text.begins_with('get '):
		var regex = RegEx.new()
		regex.compile("get\\s(?<object>.*(\\s.*)?)")
		var results = regex.search(text)
		object = results.get_string('object')
		return InstructionSet.GET

	if text.begins_with('open '):
		var regex = RegEx.new()
		regex.compile("open\\s(?<object>.*(\\s.*)?)")
		var results = regex.search(text)
		object = results.get_string('object')
		return InstructionSet.OPEN

	if text.begins_with('close '):
		var regex = RegEx.new()
		regex.compile("close\\s(?<object>.*(\\s.*)?)")
		var results = regex.search(text)
		object = results.get_string('object')
		return InstructionSet.CLOSE

	return InstructionSet.NOT_FOUND

func get_object():
	return object
