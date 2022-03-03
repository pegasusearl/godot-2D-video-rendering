extends FileDialog


func _ready():
	var dir = Directory.new()
	dir.make_dir("/tmp/render")


func _on_RenderSettings_select_render_dir(input_dir):
	current_dir = input_dir
	popup_centered()
