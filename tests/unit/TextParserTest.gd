extends GutTest

var TextParser = load('res://src/TextParser.gd')
var InstructionSet = load('res://src/InstructionSet.gd')
var text_parser = null

func before_each():
	text_parser = TextParser.new()

func test_direction_is_parsed_correctly():
	var directions = {
		"go north": InstructionSet.NORTH,
		"north": InstructionSet.NORTH,
		"go south": InstructionSet.SOUTH,
		"south": InstructionSet.SOUTH,
		"go east": InstructionSet.EAST,
		"east": InstructionSet.EAST,
		"go west": InstructionSet.WEST,
		"west": InstructionSet.WEST,
	}
	for direciton in directions:
		var passedText = direciton
		var instruction = text_parser.parse(passedText)
		assert_eq(instruction, directions[direciton])

