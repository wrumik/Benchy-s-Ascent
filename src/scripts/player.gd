extends CharacterBody2D

const SPEED: float = 150.0

@onready var player_sprite: AnimatedSprite2D = $PlayerSprite
@onready var interaction_cast: RayCast2D = $InteractionCast

var interaction_cast_length: float = 3.0
var direction: Vector2 = Vector2.ZERO

var interaction_cast_positions: Dictionary[String, Vector2] = {
	"left": Vector2(-6, -2),
	"right": Vector2(6, -2),
	"up": Vector2(0, -3.5),
	"down": Vector2(0, -0.5)
}


func _unhandled_input(_event: InputEvent) -> void:
	direction = Input.get_vector("left","right","up","down")
	update_animations()


func _physics_process(_delta: float) -> void:
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()


func update_animations():
	if direction.x > 0:
		player_sprite.play("walk_right")
		interaction_cast.position = interaction_cast_positions["right"]
		interaction_cast.target_position = Vector2(interaction_cast_length, 0)
	elif direction.x < 0:
		player_sprite.play("walk_left")
		interaction_cast.position = interaction_cast_positions["left"]
		interaction_cast.target_position = Vector2(-interaction_cast_length, 0)
	elif direction.y < 0:
		player_sprite.play("walk_up")
		interaction_cast.position = interaction_cast_positions["up"]
		interaction_cast.target_position = Vector2(0, -interaction_cast_length)
	elif direction.y > 0:
		player_sprite.play("walk_down")
		interaction_cast.position = interaction_cast_positions["down"]
		interaction_cast.target_position = Vector2(0, interaction_cast_length)
	else:
		player_sprite.stop()
