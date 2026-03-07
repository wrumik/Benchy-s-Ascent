extends BattleEnemy

@onready var scaliop_sprite: AnimatedSprite2D = $ScaliopSprite
@onready var attack_pivot: Node2D = $AttackPivot

var attack_cooldown: int = 3
var current_attack_cooldown: int = 3
var attack_ready: bool = false

@export var attack_projectile_scene: PackedScene

var possible_movement_directions: Dictionary[String, Vector2] = {
	"up_left": Vector2(-1, -1),
	"left": Vector2(-1, 0),
	"down_left": Vector2(-1, 1),
	"up": Vector2(0, -1),
	"down": Vector2(0, 1),
	"up_right": Vector2(1, -1),
	"right": Vector2(1, 0),
	"down_right": Vector2(1, 1)
	}

func _on_decision_timer_timeout():
	current_attack_cooldown -= 1
	if current_attack_cooldown > 0:
		move_to_random_tile()
	else:
		if player.global_position.y < global_position.y and attack_ready:
			if grid.move_to_tile(target_position, possible_movement_directions["up"]):
				scaliop_sprite.play("jump")
				await scaliop_sprite.animation_finished
				attack()
		if player.global_position.y > global_position.y and attack_ready:
			if grid.move_to_tile(target_position, possible_movement_directions["down"]):
				scaliop_sprite.play("jump")
				await scaliop_sprite.animation_finished
				attack()
		else:
			move_to_random_tile()


func move_to_random_tile():
	if grid.move_to_tile(target_position, possible_movement_directions.values().pick_random()):
		scaliop_sprite.play("jump")
	if current_attack_cooldown < 0 and !attack_ready:
		attack_ready = true


func attack():
	current_attack_cooldown = 3
	scaliop_sprite.play("attack")
	var projectile_instance: Hazard = attack_projectile_scene.instantiate()
	add_sibling(projectile_instance)
	projectile_instance.global_position = attack_pivot.global_position
