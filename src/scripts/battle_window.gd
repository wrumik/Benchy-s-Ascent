extends MarginContainer

const HORIZONTAL_CELL_DISTANCE: int = 96
const VERTICAL_CELL_DISTANCE: int = 68
var cell_size_x: int = 96
var cell_size_y: int = 68
var current_player_cell: Vector2 = Vector2(1, 1)
var first_cell_position: Vector2 = Vector2(192, 272)


@onready var player_sprite: AnimatedSprite2D = $PlayerSprite


func _ready() -> void:
	pass


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left"):
		pass
	if Input.is_action_just_pressed("right"):
		pass
	if Input.is_action_just_pressed("up"):
		pass
	if Input.is_action_just_pressed("down"):
		pass


func move_to_cell(cell_coords: Vector2):
	pass


func local_to_map(x_coordinate: float, y_coordinate: float):
	return Vector2i(int(x_coordinate - first_cell_position.x / cell_size_x), int(y_coordinate / cell_size_y))


func map_to_local(x_coordinate: int, y_coordinate: int):
	return Vector2((x_coordinate * cell_size_x) + cell_size_x / 2, (y_coordinate * cell_size_y) + cell_size_y / 2)
