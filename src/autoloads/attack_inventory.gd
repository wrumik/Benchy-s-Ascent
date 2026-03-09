extends Node

var category_1_starter_attack: PlayerAttackItemResource = load("res://src/resources/slash_attack.tres")
var category_2_starter_attack: PlayerAttackItemResource = load("res://src/resources/heal_attack.tres")
var category_3_starter_attack: PlayerAttackItemResource = load("res://src/resources/block_attack.tres")

var attacks: Array[PlayerAttackItemResource] = [
	category_1_starter_attack,
	category_2_starter_attack,
	category_3_starter_attack
]
