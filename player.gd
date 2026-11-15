
extends CharacterBody2D

@export var bullet_scene: PackedScene

const SPEED = 300.0
const SPRINT_SPEED = 500.0
const JUMP = -650.0

const ACCELERATION = 1800.0
const FRICTION = 2200.0
const GRAVITY_MULTIPLIER = 1.5

var health = 5
var health_bar: ProgressBar
var shoot_timer = 0.0
var is_dead = false

func _ready():
	add_to_group("player")

	var ui = CanvasLayer.new()
	add_child(ui)

	health_bar = ProgressBar.new()
	health_bar.max_value = 5
	health_bar.value = health
	health_bar.position = Vector2(20, 20)
	health_bar.size = Vector2(220, 25)
	health_bar.show_percentage = false
	ui.add_child(health_bar)

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * SPEED

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP

	move_and_slide()

	shoot_timer -= delta

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if shoot_timer <= 0:
			shoot()
			shoot_timer = 0.25

func shoot():
	if bullet_scene == null:
		print("ERROR: Bullet Scene is not assigned!")
		return

	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)

	bullet.global_position = $Gun.global_position
	bullet.direction = (get_global_mouse_position() - $Gun.global_position).normalized()
	bullet.target_group = "enemies"

	$GunSound.play()

func take_damage(amount):
	if is_dead:
		return

	health = max(health - amount, 0)
	health_bar.value = health

	print("PLAYER HP: ", health)

	if health <= 0:
		is_dead = true
		$DeathSound.play()
		await $DeathSound.finished
		get_tree().reload_current_scene()
