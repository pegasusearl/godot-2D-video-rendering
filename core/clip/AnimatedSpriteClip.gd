extends AnimatedSprite
class_name AnimatedSpriteClip

var loop := false
var frame_count := 1
var fps := 0

var current_duration = 0.0

var length := 1.0
var length_plus_delay := 1.1
var frame_delay := 0.1


func _ready():
	stop()
	loop = frames.get_animation_loop(animation)
	frame_count = frames.get_frame_count(animation)
	fps = frames.get_animation_speed(animation)
	frame_delay = 1.0/fps
	
	length = frame_delay*frame_count
	length_plus_delay = length+frame_delay
	
	_visibility_changed()
	connect("visibility_changed",self,"_visibility_changed")


func _progress_duration(amount:float):
	if loop:
		if current_duration >= length_plus_delay:
			current_duration -= length_plus_delay
	current_duration += amount
	frame = floor(current_duration/frame_delay)


func _visibility_changed():
	# Damn it only detect if this object's visible var is true
	# it does not detect if it's actually visible. 
	# you know, parent's visibility status.
	if visible:
		VideoRenderServer.connect("progress_duration",self,"_progress_duration")
	else:
		VideoRenderServer.disconnect("progress_duration",self,"_progess_duration")
