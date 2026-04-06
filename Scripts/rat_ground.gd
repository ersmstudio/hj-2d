extends CharacterBody2D
var speed =25
var playerChase=false
var player= null

func _physics_process(delta):
	if playerChase:
		position +=(player.position-position)/speed
		$RatAnimation.play("Walk")
		if(player.position.x - position.x)<0:
			$RatAnimation.flip_h=true
		else:
			$RatAnimation.flip_h=false
	else:
		$RatAnimation.play("Idle")

func _on_detection_area_body_entered(body):
	player = body
	playerChase =true


func _on_detection_area_body_exited(body):
	player =null
	playerChase=false
