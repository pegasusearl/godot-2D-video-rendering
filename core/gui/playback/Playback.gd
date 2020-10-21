extends Control


onready var gui = get_node("../../../..")
const THIS = 0

var active:bool = true


func _on_Menu_tab_changed(tab):
	active = (tab == THIS)
	if active:
		reset_gui()
	else:
		delay = 3.0
		set_process(false)
		gui.show()


func reset_gui():
	gui.show()
	delay = 3.0
	set_process(true)


var delay := 0.0
func _process(delta):
	print(delay)
	delay -= delta
	if delay < 0.0:
		gui.hide()
		set_process(false)


func _input(event):
	if active:
		reset_gui()
