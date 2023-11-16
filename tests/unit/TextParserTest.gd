extends GutTest

var TextParser = load('res://src/TextParser.gd')
var InstructionSet = load('res://src/InstructionSet.gd')
var text_parser = null

func before_each():
	text_parser = TextParser.new()

func test_random_text_produces_error():
	var entered_text = {
		"": InstructionSet.NOT_FOUND,
		" ":  InstructionSet.NOT_FOUND,
		"wibble":  InstructionSet.NOT_FOUND,
		"notrhitng":  InstructionSet.NOT_FOUND,
		"wewst":  InstructionSet.NOT_FOUND,
		"southgsd":  InstructionSet.NOT_FOUND,
		"estesin":  InstructionSet.NOT_FOUND,
		"<script>":  InstructionSet.NOT_FOUND,
	}
	for text in entered_text:
		assert_eq(text_parser.parse(text), entered_text[text])

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
		assert_eq(text_parser.parse(direciton), directions[direciton])

func test_help_is_parsed_correctly():
	var tests = {
		"help": InstructionSet.HELP,
		"help me": InstructionSet.HELP,
	}
	for test in tests:
		assert_eq(text_parser.parse(test), tests[test])

func test_look_is_parsed_correctly():
	assert_eq(text_parser.parse('look'), InstructionSet.LOOK)

func test_reset_is_parsed_correctly():
	assert_eq(text_parser.parse('reset'), InstructionSet.RESET)

func test_quit_is_parsed_correctly():
	var tests = {
		"quit": InstructionSet.QUIT,
		"exit": InstructionSet.QUIT,
	}
	for test in tests:
		assert_eq(text_parser.parse(test), tests[test])

func test_object_commands_are_parsed_correctly():
	assert_eq(text_parser.parse("get"), InstructionSet.NOT_FOUND)
	assert_eq(text_parser.parse("getbucket"), InstructionSet.NOT_FOUND)
	assert_eq(text_parser.parse("get-bucket"), InstructionSet.NOT_FOUND)

	var tests = {
		"get bucket": {
			'instruction': InstructionSet.GET,
			'object': 'bucket',
		},
		"drop bucket": {
			'instruction': InstructionSet.DROP,
			'object': 'bucket',
		},
		"open north door": {
			'instruction': InstructionSet.OPEN,
			'object': 'north door',
		},
		"close north door": {
			'instruction': InstructionSet.CLOSE,
			'object': 'north door',
		},
	}
	for test in tests:
		var instruction = text_parser.parse(test)
		assert_eq(instruction, tests[test]['instruction'])
		var object = text_parser.get_object()
		assert_eq(object , tests[test]['object'])
