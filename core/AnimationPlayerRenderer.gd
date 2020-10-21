extends AnimationPlayer
class_name AnimationPlayerRenderer


signal render_finished (last_frame)


# set this to true if you only want to preview instead of actually render.
export var preview_only:bool = false # DEPRECATED

export var render_directory:String = "/tmp/render"
export var file_name:String = "image"


var savepath:String

export var animation_to_render:String = "New Anim"
export var fps:int = 12

var frame_number := 0
var current_duration := 0.0
var length := 0.0

var frame_delay := 0.1


func _ready():
	
	VideoRenderServer.main_render_node = self
	set_physics_process(false)
	
	VideoRenderServer._main_render_node_is_ready()
	
	return
	#DEPRECATED
	
	if preview_only:
		play(animation_to_render)
		connect("animation_finished",self,"_preview_ended")
		return


func _preview_ended(animation_name):
	play(current_animation)


func prepare_to_record():
	if autoplay != "":
		print("AUTOPLAY IS ON!! TURN IT OFF!! ",autoplay)
		return str("AUTOPLAY IS ON!! TURN IT OFF!! ",autoplay)
	
	fps = abs(fps)
	if fps == 0:
		print("FPS is 0! This is animation man! Aborting...")
		return str("FPS is 0! This is animation man! Aborting...")
	
	if file_name == "":
		print("File name is blank you idiot! How do you even make that mistake?! There is a default name. Aborting...")
		return str("File name is blank you idiot! How do you even make that mistake?! There is a default name. Aborting...")
	
	if !has_animation(animation_to_render):
		print("Animation ",animation_to_render," does not exist! Aborting...")
		return str("Animation ",animation_to_render," does not exist! Aborting...")
	
	var directory: = Directory.new()
	var err = directory.make_dir(render_directory)
	if ![OK,ERR_ALREADY_EXISTS].has(err):
		print("Cannot make dir in ",render_directory," error code ",err)
		return str("Cannot make dir in ",render_directory," error code ",err)
	
	
	file_name = file_name.trim_suffix(".png")
	savepath = render_directory.rstrip("/") + file_name
	
	current_animation = animation_to_render
	stop()
	seek(current_duration,true)
	
	length = get_animation(animation_to_render).length
	frame_delay = 1.0/fps
	current_duration = 0.0
	
	# call_deferred("start_recording")
	return OK


var record_delay := 3
func start_recording():
	record_delay = 3
	set_physics_process(true)


func record():
	seek(current_duration,true)
	var frame = str(frame_number).pad_zeros(4)
	
	# From Calinou
	get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	#----
	
	var image = get_viewport().get_texture().get_data()
	
	image.flip_y()
	if record_delay > 0:
		image.save_png(render_directory+"/"+file_name+str(frame)+".png")
	else:
		record_delay -= 1
	
	frame_number += 1
	
	if current_duration >= length:
		print("DONE!!")
		emit_signal("render_finished",frame_number)
		set_physics_process(false)
	
	current_duration += frame_delay
	VideoRenderServer.emit_signal("progress_duration",frame_delay)
	
	print("[",current_duration,"/",length,"]")


func _physics_process(delta):
	record()


