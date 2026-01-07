extends CanvasLayer

@export var Path: PackedScene
@onready var QuitAnim: AnimationPlayer = $AnimationPlayer

func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(Path) 

func _on_settings_pressed() -> void:
	pass

func _on_creators_pressed() -> void:
	pass

func _on_quit_pressed() -> void:
	QuitAnim.play("OpenPanel")

func _on_yes_pressed() -> void:
	get_tree().quit()

func _on_no_pressed() -> void:
	QuitAnim.play("ClosePanel")
