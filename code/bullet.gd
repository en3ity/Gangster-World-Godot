extends Area2D

var direction = Vector2.RIGHT
var speed = 750.0
var target_group = "enemies"

func _ready():
	$Polygon2D.polygon = PackedVector2Array([
		Vector2(-8, -3),
		Vector2(8, -3),
		Vector2(8, 3),
		Vector2(-8, 3)
	])
	$Polygon2D.color = Color.YELLOW
	body_entered.connect(hit)

func _physics_process(delta):
	global_position += direction * speed * delta

func hit(body):
	if body.is_in_group(target_group):
		if body.has_method("take_damage"):
			body.take_damage(1)
			queue_free()
			return

	if body is TileMapLayer or body is TileMap:
		queue_free()
		

func _on_body_entered(body: Node2D) -> void:
	hit(body)
