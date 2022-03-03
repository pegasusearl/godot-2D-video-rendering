extends CheckButton


func _ready():
	pressed = VideoRenderServer.prescise_sub_animation_seeking


func _on_PresciseSubSeeking_toggled(button_pressed):
	VideoRenderServer.prescise_sub_animation_seeking = button_pressed
