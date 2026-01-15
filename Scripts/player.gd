extends CharacterBody2D

@export var Speed: float = 170.0
@export var JUMP_VELOCITY: float = -300.0
@export var HOLD_JUMP_FORCE: float = -500.0
@export var Platform: bool = false
@export var Camera: bool = true
@export var jump_time := 0.0
@export var MAX_JUMP_TIME := 0.2

@onready var TopDownColl: CollisionShape2D = $TDCollision
@onready var PlatformColl: CollisionShape2D = $PFCollision
@onready var PlayerAnim: AnimatedSprite2D = $PlayerAnimation

func _physics_process(delta):
	if Camera:
		$Camera2D.enabled = true
	else:
		$Camera2D.enabled = false
	
	if Platform:
		# ========= PLATFORM MODE =========
		PlatformColl.disabled = false
		TopDownColl.disabled = true

		# Gravity
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Horizontal movement
		var dir := Input.get_axis("Left", "Right")
		velocity.x = dir * Speed

		# Flip
		if dir != 0:
			PlayerAnim.flip_h = dir < 0

		# Jump
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		
		elif Input.is_action_pressed("Jump") and not is_on_floor() and velocity.y < 0:
			velocity.y += HOLD_JUMP_FORCE * delta



		# Animations (Platform)
		if not is_on_floor():
			PlayerAnim.play("Jump")
		else:
			if dir == 0:
				PlayerAnim.play("Idle")
			else:
				PlayerAnim.play("Walk")

		move_and_slide()

	else:
		# ========= TOP DOWN MODE =========
		PlatformColl.disabled = true
		TopDownColl.disabled = false

		var dir := Vector2(
			Input.get_axis("Left", "Right"),
			Input.get_axis("Up", "Down")
		)

		if dir != Vector2.ZERO:
			velocity = dir.normalized() * Speed

			# Animations (TopDown)
			if abs(dir.x) > abs(dir.y):
				PlayerAnim.play("Walk")
				PlayerAnim.flip_h = dir.x < 0
			else:
				if dir.y < 0:
					PlayerAnim.play("WalkUp")
				else:
					PlayerAnim.play("WalkDown")
		else:
			velocity = Vector2.ZERO
			PlayerAnim.play("Idle")

		move_and_slide()
