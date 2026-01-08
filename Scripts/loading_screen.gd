extends CanvasLayer

@export var Path: PackedScene

func _ready():
	$Loading/Panel/AnimationPlayer.play("LoadingS")
	await get_tree().create_timer(8).timeout
	get_tree().change_scene_to_packed(Path)
