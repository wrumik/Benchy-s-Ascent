extends Hazard

var speed: float = 400.0


func _ready() -> void:
	get_tree().create_timer(2).timeout.connect(queue_free)


func _process(delta: float) -> void:
	global_position.x -= speed * delta
