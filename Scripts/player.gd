extends CharacterBody2D

enum State {
	IDLE,
	RUN,
	WALK,
	HIT,
	JUMP,
	TAKEDAMAGE,
	DEAD
	
}




@export_category("Stats")
@export var speed: int =400

var state:State = State.IDLE


var move_direction: Vector2 =Vector2(0,0)


func _physics_process(_delta: float) -> void:
	movement_loop()

@onready var animation_tree: AnimationTree= $AnimationTree
@onready var animation_playback: AnimationNodeStateMachinePlayback= $AnimationTree["parameters/playback"]

func movement_loop() -> void:
	move_direction.x = int(Input.is_action_pressed("Right")) - int(Input.is_action_pressed("Left"))
	move_direction.y = int(Input.is_action_pressed("Down")) - int(Input.is_action_pressed("Up"))
	var motion: Vector2= move_direction.normalized()* speed
	set_velocity(motion)
	move_and_slide()
	
	if state == State.IDLE or State.RUN or State.WALK:
		if move_direction.x< -0.01:
			$AnimatedSprite2D.flip_h=true
			$Sprite2D.flip_h=true
		elif move_direction.x>0.01:
			$AnimatedSprite2D.flip_h=false
			$Sprite2D.flip_h=false



	if motion != Vector2.ZERO and state ==State.IDLE:
		state =State.WALK
		update_animation()
	if motion == Vector2.ZERO and state ==State.WALK:
		state =State.IDLE
		update_animation()


func update_animation() -> void:
	match state:
		State.IDLE:
			animation_playback.travel("Hassan_Idle")
		State.RUN:
			animation_playback.travel("Hassan_Run")
		State.HIT:
			animation_playback.travel("Hassan_Hit")
		State.WALK:
			animation_playback.travel("Hassan_Walk")
		State.TAKEDAMAGE:
			animation_playback.travel("Hassan_TakeDamage")
		State.JUMP:
			animation_playback.travel("HassanJump")
		State.DEAD:
			animation_playback.travel("Hassan_Dead")
			
