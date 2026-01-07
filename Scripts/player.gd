extends CharacterBody2D

@export var Speed: float = 300.0
@export var Jump: float = -450.0
@export var Platform: bool = false

@onready var TDCollison: CollisionShape2D = $TopDownCollision
@onready var PMCollison: CollisionShape2D = $PlatformCollision
@onready var PlayerAnim: AnimatedSprite2D = $AnimatedSprite2D

var attacking := false
var in_air := false

func _physics_process(delta: float) -> void:
	TDCollison.disabled = Platform
	PMCollison.disabled = not Platform

	if Platform:
		platform_move(delta)
	else:
		top_down_move()

	move_and_slide()

func top_down_move() -> void:
	var dir := Vector2(
		Input.get_axis("Left", "Right"),
		Input.get_axis("Up", "Down")
	)

	if Input.is_action_just_pressed("Attack") and not attacking:
		attacking = true
		velocity = Vector2.ZERO
		PlayerAnim.play("Hit")
		await PlayerAnim.animation_finished
		attacking = false
		return

	if attacking:
		return

	if dir != Vector2.ZERO:
		velocity = dir.normalized() * Speed
		PlayerAnim.play("Walk")
		if dir.x != 0:
			PlayerAnim.flip_h = dir.x < 0
	else:
		velocity = Vector2.ZERO
		PlayerAnim.play("Idle")

func platform_move(delta: float) -> void:
	var dir_x := Input.get_axis("Left", "Right")
	velocity.x = dir_x * Speed

	if is_on_floor():
		if in_air:
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
