extends AnimationPlayer
class_name AnimationPlayerRenderer


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
	
	set_process(false)
	
	if autoplay != "":
		print("AUTOPLAY IS ON!! TURN IT OFF!! ",autoplay)
		get_tree().quit()
		return
	
	fps = abs(fps)
	if fps == 0:
		print("FPS is 0! This is animation man! Aborting...")
		get_tree().quit()
		return
	
	if file_name == "":
		print("File name is blank you idiot! How do you even make that mistake?! There is a default name. Aborting...")
		get_tree().quit()
		return
	
	if !has_animation(animation_to_render):
		print("Animation ",animation_to_render," does not exist! Aborting...")
		get_tree().quit()
		return
	
	var directory: = Directory.new()
	var err = directory.make_dir(render_directory)
	if ![OK,ERR_ALREADY_EXISTS].has(err):
		print("Cannot make dir in ",render_directory," error code ",err)
		get_tree().quit()
		return
	
	
	file_name = file_name.trim_suffix(".png")
	savepath = render_directory.rstrip("/") + file_name
	
	current_animation = animation_to_render
	stop()
	seek(current_duration,true)
	
	length = get_animation(animation_to_render).length
	frame_delay = 1.0/fps
	current_duration = 0.0
	
	call_deferred("start_recording")


func start_recording():
	set_process(true)


func record():
	seek(current_duration,true)
	var frame = str(frame_number).pad_zeros(4)
	
	# From Calinou
	get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	#----
	
	var image = get_viewport().get_texture().get_data()
	
	image.flip_y()
	image.save_png(render_directory+"/"+file_name+str(frame)+".png")
	
	if current_duration >= length:
		print("DONE!!")
		get_tree().quit()
		set_process(false)
	
	frame_number += 1
	current_duration += frame_delay
	VideoRenderServer.emit_signal("progress_duration",frame_delay)
	
	print("[",current_duration,"/",length,"]")


func _process(delta):
	record()


