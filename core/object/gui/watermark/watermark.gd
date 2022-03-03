extends CenterContainer


signal request_add_watermark

onready var main = get_node("../../../../..")
onready var list = $pc/vb/ItemList


func _ready():
	pass


func _on_add_watermark_pressed():
	emit_signal("request_add_watermark")


func _on_watermark_add_files_selected(paths):
	for path in paths:
		var watermark = load(path).instance()
		main.watermark_container.add_child(watermark)
		list.add_item(str(watermark.name,"/",path))


func _on_remove_selected_pressed():
	print("removing watermark code not finished yet. man I thought it's gonna be that simple.")
	return
	for item in list.get_selected_items():
		item = item.split("/")
		
		var wm_node = main.watermark_container.get_node(item[0])
		if wm_node != null:
			wm_node.queue_free()
		
		list.remove_item()
