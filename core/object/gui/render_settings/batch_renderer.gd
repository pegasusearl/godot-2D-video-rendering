extends VBoxContainer


func _ready():
	pass


func _on_active_toggled(button_pressed):
	$hb.visible = button_pressed
