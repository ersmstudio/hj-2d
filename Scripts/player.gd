extends CharacterBody2D

@export var Speed: float = 150.0
@export var Jump: float = -300.0
@export var Platform: bool = false

@onready var TopDownColl: CollisionShape2D = $TDCollision
@onready var PlatformColl: CollisionShape2D = $PFCollision
@onready var PlayerAnim: AnimatedSprite2D = $PlayerAnimation

func _physics_process(delta):
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
			velocity.y = Jump

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
