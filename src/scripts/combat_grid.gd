extends Node2D

@onready var enemies: Node2D = $Enemies
@onready var player: Area2D = $Player
@onready var player_sprite: AnimatedSprite2D = $Player/PlayerSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer

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

# DELETE LATER
var test_battle: String = "res://src/battles/test_battle.json"


func _ready() -> void:
	generate_grid()
	target_position = map_to_local(Vector2(1, 1))
	# DELETE LINE BELOW LATER
	ready_battle(test_battle)


func ready_battle(battle_file_path):
	var battle_json_string: String = FileAccess.get_file_as_string(battle_file_path)
	var battle_state: Array = JSON.parse_string(battle_json_string)
	
	var loop_counter: int = 0
	for i in battle_state:
		#check if enemy spawn is wanted by chance
		if loop_counter != 0:
			var random_number: int = randi_range(0, 100)
			if i["chance_to_spawn"] < random_number:
				continue
		#get the scene connected to the enemy's name
		var enemy_instance: BattleEnemy = GameData.enemy_scene_dict[i["enemy_name"]].instantiate()
		enemies.add_child(enemy_instance)
		# set the spawn position of the enemy
		var spawn_position: Vector2 = map_to_local(Vector2(i["position_x"], i["position_y"]))
		enemy_instance.target_position = spawn_position
		enemy_instance.global_position = spawn_position
		enemy_instance.move_to.connect(move_to_tile)
		grid[local_to_map(spawn_position).x][local_to_map(spawn_position).y] = enemy_instance
		loop_counter += 1
	
	animation_player.play("start_of_battle")


func generate_grid():
	var cell_texture: Texture = load("res://src/sprites/tile.png")
	
	for x in grid_width:
		grid.append([])
		for y in grid_height:
			#0 means empty space 1 means occupied space
			grid[x].append(null)
			var cell: Sprite2D = Sprite2D.new()
			add_child(cell)
			cell.scale *= 2
			cell.texture = cell_texture
			cell.position = Vector2(x * (cell_size.x + cell_separation.x) + cell_offset.x,
			y * (cell_size.y + cell_separation.y) + cell_offset.y)


#moves from tile to tile forcibly
func move_to_tile(current_pos: Vector2, direction: Vector2) -> void:
	#out of bounds tile checks
	var desired_next_pos: Vector2 = (local_to_map(current_pos) + direction)
	if (desired_next_pos.x < 0 || (desired_next_pos.y) < 0):
		print("tile out of bounds")
		return
	elif (desired_next_pos.x > grid_width - 1 || desired_next_pos.y > grid_height - 1):
		print("tile out of bounds")
		return
	#occupied tile check
	elif grid[desired_next_pos.x][desired_next_pos.y] != null:
		print("tile occupied")
		return
	
	var node_to_move: Node2D = grid[local_to_map(current_pos).x][local_to_map(current_pos).y]
	
	grid[local_to_map(current_pos).x][local_to_map(current_pos).y] = null
	grid[desired_next_pos.x][desired_next_pos.y] = node_to_move
	
	node_to_move.target_position = map_to_local(desired_next_pos)


func move_player_to_tile(direction: Vector2) -> void:
	#out of bounds tile check
	var desired_next_pos: Vector2 = (local_to_map(target_position) + direction)
	if (desired_next_pos.x < 0
	|| (desired_next_pos.y) < 0):
		print("tile out of bounds")
		return
	elif (desired_next_pos.x > grid_width - 1 || desired_next_pos.y > grid_height - 1):
		print("tile out of bounds")
		return
	elif grid[desired_next_pos.x][desired_next_pos.y] != null:
		print("tile occupied")
		return
	
	grid[local_to_map(target_position).x][local_to_map(target_position).y] = null
	grid[desired_next_pos.x][desired_next_pos.y] = player
	
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
	player.global_position = lerp(player.global_position, target_position, player_move_speed * delta)
