class_name AttackItem
extends Button


@export var attack_item_resource: PlayerAttackItemResource
signal set_slot(attack_item_resource: PlayerAttackItemResource)


func _ready() -> void:
	if attack_item_resource != null:
		icon = attack_item_resource.icon_texture
		pressed.connect(signal_slot_change)


func signal_slot_change():
	set_slot.emit(attack_item_resource)
