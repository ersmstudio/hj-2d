extends CharacterBody2D

@export var Speed: float = 300.0
@export var Jump: float = -450.0
@export var Platform: bool = false
@export var AttackCooldown: float = 0.5  # مدة الهجوم بالثواني

@onready var TDCollision: CollisionShape2D = $TopDownCollision
@onready var PMCollision: CollisionShape2D = $PlatformCollision
@onready var WUCollision: CollisionShape2D = $WalkupCollision
@onready var WUAnim: AnimatedSprite2D = $AnimatedSprite2D2
@onready var PlayerAnim: AnimatedSprite2D = $AnimatedSprite2D
@onready var Shadow: Sprite2D = $Shadow

var attacking := false
var last_dir := Vector2.DOWN
var attack_timer := 0.0

func _ready() -> void:
	if Platform:
		PlayerAnim.visible = true
		WUAnim.visible = false
		PlayerAnim.play("Idle")
	else:
		PlayerAnim.visible = false
		WUAnim.visible = true
		WUAnim.play("IdleUp")

func _physics_process(delta: float) -> void:
	TDCollision.disabled = Platform
	WUCollision.disabled = Platform
	PMCollision.disabled = not Platform

	if attack_timer > 0:
		attack_timer -= delta

	if attacking:
		if Platform:
			move_and_slide()
		return

	if Input.is_action_just_pressed("Attack") and not attacking and attack_timer <= 0:
		await handle_attack()
		return

	if Platform:
		handle_platform(delta)
	else:
		handle_top_down()

	move_and_slide()

func handle_attack() -> void:
	attacking = true
	attack_timer = AttackCooldown
	velocity = Vector2.ZERO
	PlayerAnim.visible = true
	WUAnim.visible = false
	PlayerAnim.play("Hit")
	await PlayerAnim.animation_finished
	attacking = false

func handle_top_down() -> void:
	var dir := Vector2(Input.get_axis("Left", "Right"), Input.get_axis("Up", "Down"))

	if dir != Vector2.ZERO:
		last_dir = dir
		velocity = dir.normalized() * Speed
		if abs(dir.y) > abs(dir.x):
			PlayerAnim.visible = false
			WUAnim.visible = true
			WUAnim.play("WalkUp")
			WUAnim.flip_v = dir.y > 0
			Shadow.visible = false
		else:
			WUAnim.visible = false
			PlayerAnim.visible = true
			PlayerAnim.play("Walk")
			PlayerAnim.flip_h = dir.x < 0
			Shadow.visible = true
	else:
		velocity = Vector2.ZERO
		play_idle()

func play_idle() -> void:
	if abs(last_dir.y) > abs(last_dir.x):
		PlayerAnim.visible = false
		WUAnim.visible = true
		WUAnim.play("IdleUp")
		WUAnim.flip_v = last_dir.y > 0
	else:
		WUAnim.visible = false
		PlayerAnim.visible = true
		PlayerAnim.play("Idle")
		PlayerAnim.flip_h = last_dir.x < 0

func handle_platform(delta: float) -> void:
	WUAnim.visible = false
	PlayerAnim.visible = true

	var dir_x := Input.get_axis("Left", "Right")
	velocity.x = dir_x * Speed

	if is_on_floor():
		if Input.is_action_just_pressed("Jump"):
			velocity.y = Jump
			PlayerAnim.play("Jump")
		elif dir_x != 0:
			PlayerAnim.play("Walk")
			PlayerAnim.flip_h = dir_x < 0
		else:
			PlayerAnim.play("Idle")
	else:
		velocity.y += ProjectSettings.get_setting("physics/2d/default_gravity") * delta
		velocity.y = min(velocity.y, 1000)
