extends CanvasLayer

@export var Path: PackedScene

func _ready():
	$Control/Panel/AnimationPlayer.play("introP")
	await get_tree().create_timer(8).timeout
	get_tree().change_scene_to_packed(Path)
