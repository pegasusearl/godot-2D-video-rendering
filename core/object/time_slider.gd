extends ProgressBar


export(NodePath) var gui_path := ""
onready var gui = get_node(gui_path)


func _process(delta):
	if VideoRenderServer.render_node_available() and VideoRenderServer.main_render_node.is_playing():
		value = VideoRenderServer.main_render_node.current_animation_position/VideoRenderServer.main_render_node.current_animation_length


func _on_TimeSlider_value_changed(value):
	print("value changed to ",value)


func _on_GUI_visibility_changed():
	set_process(gui.visible)
