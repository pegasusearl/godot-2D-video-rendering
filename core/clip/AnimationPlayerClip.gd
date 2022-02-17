extends AnimationPlayer
class_name AnimationPlayerClip

var loop := false

var current_duration = 0.0
var length := 1.0

export var force_looping:bool = true
export var prefer_using_autoplay:bool = false

func _ready():
	
	if autoplay != "" and prefer_using_autoplay:
		if current_animation != autoplay:
			print("current_animation and autoplay is different. autoplay is preferred.")
		current_animation = autoplay
	
	if current_animation == "":
		if get_animation_list().size() > 0:
			current_animation = get_animation_list()[0]
			print("current_animation is blank, using first animation : ",current_animation)
		else:
			print("current_animation is blank and no animation at all. Nothing to do.")
			return
	
	current_duration = 0.0
	
	if force_looping:
		loop = true
	else:
		loop = get_animation(current_animation).loop
	length = get_animation(current_animation).length
	stop()
	
	VideoRenderServer.connect("progress_duration",self,"_progress_duration")
	VideoRenderServer.connect("preview_animation",self,"start_preview")


func start_preview():
	seek(0,true)
	if force_looping:
		loop = true
	play(current_animation)


func _progress_duration(amount:float):
	seek(current_duration,true)
	current_duration += amount
	if loop and current_duration >= length:
		current_duration -= length
