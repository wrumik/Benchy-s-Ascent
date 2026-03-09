extends CenterContainer

@onready var item_grid: GridContainer = $HBoxContainer/TextureRect/MarginContainer/VBoxContainer/GridContainer
@onready var page_label: Label = $HBoxContainer/TextureRect/MarginContainer/VBoxContainer/HBoxContainer/PageLabel
@onready var slot_1_icon: TextureRect = $HBoxContainer/VBoxContainer/Slot1Container/Slot1Icon
@onready var slot_2_icon: TextureRect = $HBoxContainer/VBoxContainer/Slot2Container/Slot2Icon
@onready var slot_3_icon: TextureRect = $HBoxContainer/VBoxContainer/Slot3Container/Slot3Icon

@export var player: Area2D

var slots_per_page: int = 40
var current_page: int = 1
var page_count: int = 1

signal resume_battle

func _ready() -> void:
	@warning_ignore("integer_division")
	#has to be slots_per_page + 1 to not show another page when the player has 40 items
	page_count = (AttackInventory.attacks.size() / slots_per_page + 1)
	show_page(1)


func show_page(page_number: int):
	if page_number > page_count or page_number < 1:
		return
	
	current_page = page_number
	page_label.text = "page " + str(page_number) + " of " + str(page_count)
	
	for i in item_grid.get_children():
		i.queue_free()
	
	for i in slots_per_page:
		var current_slot: int = (page_number - 1) * slots_per_page + i
		if AttackInventory.attacks.size() <= current_slot:
			break
		var item: AttackItem = AttackItem.new()
		item.attack_item_resource = AttackInventory.attacks[current_slot]
		item.set_slot.connect(set_equipped)
		item_grid.add_child(item)


func _on_arrow_button_right_pressed() -> void:
	show_page(current_page + 1)


func _on_arrow_button_left_pressed() -> void:
	show_page(current_page - 1)


func focus_first_slot():
	var first_item: AttackItem = item_grid.get_child(0)
	first_item.grab_focus()


func set_equipped(attack_item_resource: PlayerAttackItemResource):
	match attack_item_resource.category:
		1:
			player.slot_1_attack = attack_item_resource
			slot_1_icon.texture = player.slot_1_attack.icon_texture
		2:
			player.slot_2_attack = attack_item_resource
			slot_2_icon.texture = player.slot_2_attack.icon_texture
		3:
			player.slot_3_attack = attack_item_resource
			slot_3_icon.texture = player.slot_3_attack.icon_texture


func _on_confirm_button_pressed() -> void:
	if player.slot_1_attack != null and player.slot_2_attack != null and player.slot_3_attack != null:
		resume_battle.emit()
