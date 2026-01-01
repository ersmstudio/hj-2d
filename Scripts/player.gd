extends CharacterBody2D

enum State {
	IDLE,
	RUN,
	Walk,
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
@onready var animation_playback: AnimationNodeStateMachine= $AnimationTree["parameters/playback"]

func movement_loop() -> void:
	move_direction.x = int(Input.is_action_pressed("Right")) - int(Input.is_action_pressed("Left"))
	move_direction.y = int(Input.is_action_pressed("Down")) - int(Input.is_action_pressed("Up"))
	var motion: Vector2= move_direction.normalized()* speed
	set_velocity(motion)
	move_and_slide()
	
	
	if motion != Vector2.ZERO and state ==State.IDLE:
		state =State.RUN
