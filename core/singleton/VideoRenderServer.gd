extends CanvasLayer

var mode
enum Mode {RENDER,PREVIEW}
signal progress_duration (amount)

onready var notification = $GUI/Popup/notification
onready var gui = $GUI

var main_render_node:AnimationPlayerRenderer

var queued_action = Action.NONE
enum Action {NONE,BATCH_RENDER}


func _ready():
	pass # Replace with function body.


func _on_Close_pressed():
	get_tree().quit()


func _on_RenderSettings_rendering_requested(render_dir, file_name, fps):
	if main_render_node == null:
		print("No main render node yet")
	else:
		start_rendering(render_dir, file_name, fps)


func start_rendering(render_dir, file_name, fps,starting_frame:int = 0):
	printt("request rendering",render_dir,file_name,fps,main_render_node.name)
	main_render_node.render_directory = render_dir
	main_render_node.file_name = file_name
	main_render_node.fps = fps
	main_render_node.frame_number = starting_frame
	var err = main_render_node.prepare_to_record()
	
	if err != OK:
		print("[ERROR] ",err)
		return
	
	main_render_node.start_recording()
	main_render_node.connect("render_finished",self,"_render_finished")
	gui.hide()


var batch_frame_count = 0
var render_queue = []
#render_dir, file_name, fps
var que_render_dir:String
var que_file_name:String
var que_fps
func _on_RenderSettings_batch_rendering_requested(render_dir, file_name, fps, queued_list):
	render_queue = queued_list
	queued_action = Action.BATCH_RENDER
	batch_frame_count = 0
	que_render_dir = render_dir
	que_file_name = file_name
	que_fps = fps
	_render_finished()


func _render_finished( last_frame=0 ):
	match queued_action:
		Action.NONE:
			gui.show()
		Action.BATCH_RENDER:
			if render_queue.size() > 0:
				batch_frame_count = last_frame
				get_tree().change_scene(render_queue[0])
			else:
				queued_action = Action.NONE
				_render_finished()


func _main_render_node_is_ready():
	print(main_render_node.name," is ready.")
	match queued_action:
		Action.NONE:
			main_render_node.play(main_render_node.animation_to_render)
			main_render_node.connect("animation_finished",main_render_node,"_preview_ended")
		Action.BATCH_RENDER:
			render_queue.pop_front()
			start_rendering(que_render_dir,que_file_name,que_fps,batch_frame_count)
			

