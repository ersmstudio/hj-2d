extends CharacterBody2D

@export var Speed: float = 300.0
@export var Jump: float = -450.0
@export var Platform: bool = false

@onready var TDCollision: CollisionShape2D = $TopDownCollision
@onready var PMCollision: CollisionShape2D = $PlatformCollision
@onready var WUCollision: CollisionShape2D = $WalkupCollision
@onready var WUAnim: AnimatedSprite2D = $WalkUp
@onready var PlayerAnim: AnimatedSprite2D = $AnimatedSprite2D
@onready var Shadow: Sprite2D = $Shadow

var attacking := false
var in_air := false
var last_dir := Vector2.DOWN

const WALK_UP_POS := Vector2(-7.774, -55.898)
const WALK_DOWN_POS := Vector2(-5.547, 105.0875)

func _physics_process(delta: float) -> void:
	TDCollision.disabled = Platform
	WUCollision.disabled = Platform
	PMCollision.disabled = not Platform

	handle_attack()

	if attacking:
		move_and_slide()
		return

	if Platform:
		platform_move(delta)
	else:
		top_down_move()

	move_and_slide()

func handle_attack() -> void:
	if Input.is_action_just_pressed("Attack") and not attacking:
		attacking = true
		velocity = Vector2.ZERO
		PlayerAnim.visible = true
		WUAnim.visible = false
		PlayerAnim.position = WALK_DOWN_POS
		PlayerAnim.play("Hit")
		await PlayerAnim.animation_finished
		attacking = false

func top_down_move() -> void:
	var dir := Vector2(
		Input.get_axis("Left", "Right"),
		Input.get_axis("Up", "Down")
	)

	if dir != Vector2.ZERO:
		last_dir = dir
		velocity = dir.normalized() * Speed

		if abs(dir.y) > abs(dir.x):
			PlayerAnim.visible = false
			WUAnim.visible = true
			WUAnim.position = WALK_UP_POS
			WUAnim.play("WalkUp")
			WUAnim.flip_v = dir.y > 0
			Shadow.visible = false
		else:
			WUAnim.visible = false
			PlayerAnim.visible = true
			PlayerAnim.position = WALK_DOWN_POS
			PlayerAnim.play("Walk")
			PlayerAnim.flip_h = dir.x < 0
			Shadow.visible = true
	else:
		velocity = Vector2.ZERO
		if abs(last_dir.y) > abs(last_dir.x):
			PlayerAnim.visible = false
			WUAnim.visible = true
			WUAnim.position = WALK_UP_POS
			WUAnim.play("IdleUp")
			WUAnim.flip_v = last_dir.y > 0
		else:
			WUAnim.visible = false
			PlayerAnim.visible = true
			PlayerAnim.position = WALK_DOWN_POS
			PlayerAnim.play("Idle")
			PlayerAnim.flip_h = last_dir.x < 0

func platform_move(delta: float) -> void:
	WUAnim.visible = false
	PlayerAnim.visible = true
	PlayerAnim.position = WALK_DOWN_POS

	var dir_x := Input.get_axis("Left", "Right")
	velocity.x = dir_x * Speed

	if is_on_floor():
		in_air = false
		if Input.is_action_just_pressed("Jump"):
			velocity.y = Jump
			in_air = true
			PlayerAnim.play("Jump")
		elif dir_x != 0:
			PlayerAnim.play("Walk")
			PlayerAnim.flip_h = dir_x < 0
		else:
			PlayerAnim.play("Idle")
	else:
		velocity.y += get_gravity().y * delta
