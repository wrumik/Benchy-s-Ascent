extends Node2D

@onready var player_sprite: AnimatedSprite2D = $PlayerSprite

@export_group("grid")
@export var grid_height: int = 3
@export var grid_width: int = 6
@export_group("cells")
@export var cell_size: Vector2i = Vector2i(96, 60)
@export var cell_separation: Vector2i = Vector2i(6, 4)
@export var cell_offset: Vector2i = Vector2i(64, 288)

var grid: Array[Array]
var target_position: Vector2
var player_move_speed: float = 25.0

func _ready() -> void:
	generate_grid()
	target_position = map_to_local(Vector2(1, 1))



func generate_grid():
	var cell_texture: Texture = load("res://src/sprites/tile.png")
	
	for x in grid_width:
		grid.append([])
		for y in grid_height:
			#0 means empty space 1 means occupied space
			grid[x].append(0)
			var cell: Sprite2D = Sprite2D.new()
			add_child(cell)
			cell.scale *= 2
			cell.texture = cell_texture
			cell.position = Vector2(x * (cell_size.x + cell_separation.x) + cell_offset.x,
			y * (cell_size.y + cell_separation.y) + cell_offset.y)


#func move_to_tile(current_pos: Vector2, direction: Vector2i):
	#pass


func move_player_to_tile(direction: Vector2):
	#out of bounds tile check
	var desired_next_pos: Vector2 = (local_to_map(target_position) + direction)
	if (desired_next_pos.x < 0
	|| (desired_next_pos.y) < 0):
		print("tile out of bounds")
		return
	elif (desired_next_pos.x > grid_width - 1 || desired_next_pos.y > grid_height - 1):
		print("tile out of bounds")
		return
	elif grid[desired_next_pos.x][desired_next_pos.y] == 1:
		return
	
	grid[local_to_map(target_position).x][local_to_map(target_position).y] = 0
	grid[desired_next_pos.x][desired_next_pos.y] = 1
	
	target_position = map_to_local(desired_next_pos)



func map_to_local(cell_position: Vector2):
	return Vector2(cell_position.x * (cell_size.x + cell_separation.x) + cell_offset.x,
	cell_position.y * (cell_size.y + cell_separation.y) + cell_offset.y)


func local_to_map(global_pos: Vector2):
	return Vector2((global_pos.x - cell_offset.x) / (cell_size.x + cell_separation.x),
	(global_pos.y - cell_offset.y) / (cell_size.y + cell_separation.y))


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("left"):
		move_player_to_tile(Vector2(-1, 0))
	if Input.is_action_just_pressed("right"):
		move_player_to_tile(Vector2(1, 0))
	if Input.is_action_just_pressed("up"):
		move_player_to_tile(Vector2(0, -1))
	if Input.is_action_just_pressed("down"):
		move_player_to_tile(Vector2(0, 1))


func _process(delta: float) -> void:
	player_sprite.global_position = lerp(player_sprite.global_position, target_position, player_move_speed * delta)
