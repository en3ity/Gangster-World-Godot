
extends CharacterBody2D

@export var bullet_scene: PackedScene

var health = 3
var speed = 100.0
var player = null
var shoot_timer = 0.5

func _ready():
	add_to_group("enemies")
	$AnimatedSprite2D.modulate = Color(1, 0.4, 0.4)

func _physics_process(delta):
	if player == null:
		player = get_tree().get_first_node_in_group("player")

	if player == null:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	var distance = player.global_position - global_position

	if abs(distance.x) > 220:
		velocity.x = sign(distance.x) * speed
	else:
		velocity.x = 0

	move_and_slide()

	shoot_timer -= delta

	if shoot_timer <= 0 and abs(distance.x) < 600:
		shoot()
		shoot_timer = 1.5

func shoot():
	if bullet_scene == null:
		print("ENEMY BULLET SCENE MISSING!")
		return

	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)

	bullet.global_position = global_position
	bullet.direction = (player.global_position - global_position).normalized()
	bullet.target_group = "player"

func take_damage(amount):
	health -= amount

	if health <= 0:
		queue_free()
