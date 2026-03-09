class_name CombatScene
extends Node2D

@onready var pause_elements: Node = $PauseElements
@onready var enemies: Node2D = $PauseElements/Enemies
@onready var player: Area2D = $PauseElements/Player
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health_bar: ProgressBar = $PauseElements/PlayerHealthBar/TextureRect/MarginContainer/HBoxContainer/HealthBar
@onready var health_label: Label = $PauseElements/PlayerHealthBar/TextureRect/MarginContainer/HBoxContainer/HealthLabel
@onready var attack_choice_menu: CenterContainer = $AttackChoiceMenu

@export_group("grid")
@export var grid_height: int = 5
@export var grid_width: int = 10
@export_group("cells")
@export var cell_size: Vector2i = Vector2i(48, 30)
@export var cell_separation: Vector2i = Vector2i(6, 4)
@export var cell_offset: Vector2i = Vector2i(64, 256)
@export var enemy_tile_start: int = 5

var grid: Array[Array]


func _ready() -> void:
	generate_grid()
	player.update_health.connect(update_health_bar)
	#set the spawning position of the player
	player.target_position = map_to_local(Vector2(2, 2))
	attack_choice_menu.resume_battle.connect(attack_choice_menu_hide)


func ready_battle(battle_file_path: String):
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
		# set enemy spawn position and knowledge base to know where the player is and what tile they're on etc
		var spawn_position: Vector2 = map_to_local(Vector2(i["position_x"], i["position_y"]))
		enemy_instance.target_position = spawn_position
		enemy_instance.global_position = spawn_position
		enemy_instance.grid = self
		enemy_instance.player = player
		grid[local_to_map(spawn_position).x][local_to_map(spawn_position).y] = enemy_instance
		loop_counter += 1
	pause_battle()
	animation_player.play("start_of_battle")
	await animation_player.animation_finished
	animation_player.play("show_attack_choice_menu")


func generate_grid():
	var player_side_cell_texture: Texture = load("res://src/sprites/player_tile.png")
	var enemy_side_cell_texture: Texture = load("res://src/sprites/enemy_tile.png")
	
	for x in grid_width:
		grid.append([])
		for y in grid_height:
			#0 means empty space 1 means occupied space
			grid[x].append(null)
			var cell: Sprite2D = Sprite2D.new()
			add_child(cell)
			
			if x >= enemy_tile_start:
				cell.texture = enemy_side_cell_texture
			else:
				cell.texture = player_side_cell_texture
			
			cell.position = Vector2(x * (cell_size.x + cell_separation.x) + cell_offset.x,
			y * (cell_size.y + cell_separation.y) + cell_offset.y)


#moves from tile to tile forcibly
func move_to_tile(current_pos: Vector2, direction: Vector2) -> bool:
	#out of bounds tile checks
	var desired_next_pos: Vector2 = (local_to_map(current_pos) + direction)
	if (desired_next_pos.x < enemy_tile_start || (desired_next_pos.y) < 0):
		print("tile out of bounds")
		return false
	elif (desired_next_pos.x > grid_width - 1 || desired_next_pos.y > grid_height - 1):
		print("tile out of bounds")
		return false
	#occupied tile check
	elif grid[desired_next_pos.x][desired_next_pos.y] != null:
		print("tile occupied")
		return false
	
	var node_to_move: Node2D = grid[local_to_map(current_pos).x][local_to_map(current_pos).y]
	
	grid[local_to_map(current_pos).x][local_to_map(current_pos).y] = null
	grid[desired_next_pos.x][desired_next_pos.y] = node_to_move
	
	node_to_move.target_position = map_to_local(desired_next_pos)
	return true


func move_player_to_tile(direction: Vector2) -> void:
	#out of bounds tile check
	var desired_next_pos: Vector2 = (local_to_map(player.target_position) + direction)
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
	
	grid[local_to_map(player.target_position).x][local_to_map(player.target_position).y] = null
	grid[desired_next_pos.x][desired_next_pos.y] = player
	
	player.target_position = map_to_local(desired_next_pos)


func map_to_local(cell_position: Vector2):
	return Vector2(cell_position.x * (cell_size.x + cell_separation.x) + cell_offset.x,
	cell_position.y * (cell_size.y + cell_separation.y) + cell_offset.y)


func local_to_map(global_pos: Vector2):
	return Vector2((global_pos.x - cell_offset.x) / (cell_size.x + cell_separation.x),
	(global_pos.y - cell_offset.y) / (cell_size.y + cell_separation.y))


func pause_battle():
	for i in pause_elements.get_children():
		i.process_mode = Node.PROCESS_MODE_DISABLED


func unpause_battle():
	for i in pause_elements.get_children():
		i.process_mode = Node.PROCESS_MODE_INHERIT


func update_health_bar():
	health_bar.value = GameData.player_health
	health_label.text = str(int(health_bar.value)) + "/" + str(GameData.player_max_health)


func attack_choice_menu_show():
	animation_player.play("show_attack_choice_menu")
	pause_battle()


func attack_choice_menu_hide():
	animation_player.play_backwards("show_attack_choice_menu")
	unpause_battle()
