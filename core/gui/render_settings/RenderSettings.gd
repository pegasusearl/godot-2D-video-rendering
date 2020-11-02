extends CenterContainer


signal select_render_dir (current_dir)
signal rendering_requested (render_dir,file_name,fps)
signal batch_rendering_requested (render_dir,file_name,fps,queued_list)
signal add_queued_scene


onready var render_directory = $panel/vb/settings/render_directory
onready var main = get_node("../../../../..")


func _on_render_directory_dir_selected(dir):
	render_directory.text = dir


func get_current_dir() -> String:
	if render_directory.text == "":
		return render_directory.placeholder_text
	else:
		return render_directory.text


func get_file_name() -> String:
	if $panel/vb/settings/file_name.text == "":
		return $panel/vb/settings/file_name.placeholder_text
	else:
		return $panel/vb/settings/file_name.text


func _on_browse_pressed():
	emit_signal("select_render_dir",get_current_dir())


func _on_start_render_pressed():
	if $panel/vb/batch_renderer/active.pressed:
		
		var items = []
		var item_list_node = $panel/vb/batch_renderer/hb/list
		for i in item_list_node.get_item_count():
			items.append(item_list_node.get_item_text(i))
			
		emit_signal("batch_rendering_requested",get_current_dir(),get_file_name(),
				$panel/vb/settings/fps.value,items)
	else:
		emit_signal("rendering_requested",get_current_dir(),get_file_name(),
				$panel/vb/settings/fps.value)


func _on_add_scene_queue_pressed():
	emit_signal("add_queued_scene")


func _on_batch_render_add_files_selected(paths):
	for scene_path in paths:
		$panel/vb/batch_renderer/hb/list.add_item(scene_path)


signal set_thread (count)
func _on_thread_value_changed(value):
	emit_signal("set_thread",int(value))
