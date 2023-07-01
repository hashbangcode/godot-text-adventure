class_name TextParser

var InstructionSet = load("res://src/InstructionSet.gd")

func parse(text):
	var instructionSet = InstructionSet.new()
	match text:
		'go north':
			return instructionSet.NORTH
		'north':
			return instructionSet.NORTH
		'go south':
			return instructionSet.SOUTH
		'south':
			return instructionSet.SOUTH
		'go east':
			return instructionSet.EAST
		'east':
			return instructionSet.EAST
		'go west':
			return instructionSet.WEST
		'west':
			return instructionSet.WEST
		'look':
			return instructionSet.LOOK
		'help':
			return instructionSet.HELP
		'reset':
			return instructionSet.RESET
