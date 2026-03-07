extends RayCast2D

var current_body: PhysicsBody2D

func _process(_delta: float) -> void:
	if get_collider() is PhysicsBody2D:
		if get_collider().is_in_group("Interactible"):
			current_body = get_collider()
	else:
		current_body = null


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and current_body and !GameData.is_in_battle:
		if current_body.has_method("interact"):
			current_body.interact()
		else:
			printerr("no interaction method found")
