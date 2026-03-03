extends CharacterBody2D

@onready var player_sprite: AnimatedSprite2D = $PlayerSprite

const SPEED: float = 150.0


func _physics_process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("left","right","up","down")
	if direction:
		if direction.x:
			scale.x = scale.y * sign(direction.x)
		velocity = direction * SPEED
		player_sprite.play("walk")
	else:
		velocity = Vector2.ZERO
		player_sprite.play("default")
	
	move_and_slide()
