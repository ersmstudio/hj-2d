extends CharacterBody2D

@export var SPEED := 300.0
@onready var PlayerAnim: AnimatedSprite2D = $AnimatedSprite2D

var attacking := false

func _physics_process(delta):
	var dir := Vector2(
		Input.get_axis("Left", "Right"),
		Input.get_axis("Up", "Down")
	)

	if Input.is_action_just_pressed("Attack") and not attacking:
		attacking = true
		PlayerAnim.play("Hit")
		await PlayerAnim.animation_finished
		attacking = false

	if not attacking:
		if dir != Vector2.ZERO:
			velocity = dir.normalized() * SPEED
			PlayerAnim.play("Walk")
			if dir.x != 0:
				PlayerAnim.flip_h = dir.x < 0
		else:
			velocity = velocity.move_toward(Vector2.ZERO, SPEED)
			PlayerAnim.play("Idle")

	move_and_slide()
