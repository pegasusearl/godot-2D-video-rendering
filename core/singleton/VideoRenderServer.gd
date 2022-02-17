extends CanvasLayer

var mode
enum Mode {RENDER,PREVIEW}
signal progress_duration (amount)

onready var notification = $GUI/Popup/notification
onready var gui = $GUI
onready var watermark_container = $Watermark

var main_render_node:AnimationPlayerRenderer

var queued_action = Action.NONE
enum Action {NONE,BATCH_RENDER}

signal preview_animation

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
	
	
	if typeof(err) != TYPE_INT or err != OK:
		print("[ERROR] ",err)
		return
	
	gui.hide()
	main_render_node.call_deferred("start_recording")
	main_render_node.connect("render_finished",self,"_render_finished")


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
			
			# Here render is actually finished
			image_flush()
			
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
			preview_animation()
			main_render_node.connect("animation_finished",self,"preview_animation")
		Action.BATCH_RENDER:
			render_queue.pop_front()
			start_rendering(que_render_dir,que_file_name,que_fps,batch_frame_count)


func preview_animation(anim_name=""):
	main_render_node.play(main_render_node.animation_to_render)
	emit_signal("preview_animation")


# SAVE IMAGE FUNCTIONS

var temp_frames_count := 100
var queued_images = []
var queued_images_count := 0
func image_queue_save(image:Image,path:String):
	queued_images.append([image,path])
	queued_images_count += 1
	if queued_images_count >= 100:
		image_flush()


var thread_count = 1
func image_flush():
	main_render_node.halt = true
	yield(get_tree(),"idle_frame")
	
	#-------------------------------------
	
	# Prepare job listing
	var jobs_queue = []
	for i in thread_count:
		jobs_queue.append([])
	
	var id = 0
	
	# Assigning jobs
	for entry in queued_images:
		#entry[0].save_png(entry[1])
		jobs_queue[id].append(entry)
		id += 1
		if id > thread_count-1:
			id = 0
	
	# Creating extra thread
	var running_thread = []
	for i in thread_count -1:
		var thread = Thread.new()
		thread.start(self,"_thread_savepng",jobs_queue.front())
		jobs_queue.pop_front()
		running_thread.append(thread)
	
	
	# Main thread rendering
	var job_list = jobs_queue.front()
	for entry in job_list:
		entry[0].save_png(entry[1])
	
	# waiting other thread
	for i in running_thread:
		i.wait_to_finish()
	
	#--------------------------------
	
	queued_images_count = 0
	queued_images.clear()
	main_render_node.halt = false


func _thread_savepng(job_list):
	for entry in job_list:
		entry[0].save_png(entry[1])
	return OK


func _on_Render_set_thread(count):
	thread_count = count

