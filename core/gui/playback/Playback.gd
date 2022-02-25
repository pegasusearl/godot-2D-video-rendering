extends VBoxContainer


onready var gui = get_node("../../../..")
const THIS = 0
const AUTOHIDE_DELAY = 0.5

var active:bool = true


func _on_Menu_tab_changed(tab):
	active = (tab == THIS)
	if active:
		reset_gui()
	else:
		delay = AUTOHIDE_DELAY
		set_process(false)
		gui.show()


func reset_gui():
	gui.show()
	delay = AUTOHIDE_DELAY
	set_process(true)


var delay := 0.0
func _process(delta):
	delay -= delta
	if delay < 0.0:
		gui.hide()
		set_process(false)


func _input(event):
	if active:
		reset_gui()
	if event is InputEventMouseButton and event.button_index == 1 and not event.pressed:
		window_dragging = false


var window_dragging := false
var start_mouse_position:Vector2
var start_window_position:Vector2
var window_scale:Vector2

const WAIT_FRAME := 3
var wait := WAIT_FRAME
#var window_tween = []

func _on_Playback_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			#window_dragging = event.pressed
			if event.pressed:
				window_dragging = true
				update_window_scale()
				start_mouse_position = get_window_mouse_position()
				start_window_position = OS.window_position
		elif not event.pressed:
			match event.button_index:
				2:
					print("right click pause",randi())
					VideoRenderServer._on_Button_pressed()
				4:
					pass#print("scroll up",randi())
				5:
					pass#print("scroll down",randi())
		#print(event.button_index)
	elif window_dragging and not OS.window_fullscreen and event is InputEventMouseMotion:
		if wait > 0:
			wait -= 1
			return

		call_deferred("update_window_position")
		wait = WAIT_FRAME


func update_window_position():
	var window_movement = get_window_mouse_position()-start_mouse_position
	var destination = OS.window_position + window_movement
	OS.window_position = destination
	
	return
	var delta_per_keyframe = window_movement/float(WAIT_FRAME)
	var keyframe = destination
	#window_tween.clear()
	#window_tween.append(keyframe)
	for i in WAIT_FRAME:
		keyframe -= delta_per_keyframe
	#	window_tween.append(keyframe)


func update_window_scale():
	var window_size = OS.window_size
	var viewport_size = get_viewport().size
	window_scale = Vector2(viewport_size.x/window_size.x,viewport_size.y/window_size.y)


func get_window_mouse_position():
	var mouse_position = get_viewport().get_mouse_position()
	mouse_position = Vector2(
			round( mouse_position.x/window_scale.x ),
			round( mouse_position.y/window_scale.y))
	return mouse_position

