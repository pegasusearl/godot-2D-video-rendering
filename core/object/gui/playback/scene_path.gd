extends Label


func _ready():
	text = get_tree().current_scene.filename
