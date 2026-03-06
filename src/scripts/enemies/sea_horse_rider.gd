extends StaticBody2D

@export var connected_dialogue: DialogueResource

func interact():
	DialogueManager.show_dialogue_balloon(connected_dialogue)
