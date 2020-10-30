tool
extends Node2D
class_name SequentialModulation


export var current_sequence:float = 0.0 setget set_sequence
var current_node_id = 0
var last_node_id_processed = 0


func _enter_tree():
	for child in get_children():
		child.modulate = Color(1,1,1,0)
	set_sequence(current_sequence)


func set_sequence(new_value:float):
	var child_count = get_child_count()
	new_value = clamp(new_value,0.0,child_count+1.0)
	
	var working_id = int(new_value)
	if working_id != last_node_id_processed:
		for i in get_children():
			i.modulate = Color(1,1,1,0)
		last_node_id_processed = working_id
	
	var alpha = new_value-working_id
	var id_before = working_id-1
	var id_after = working_id+1
	
	if id_before >= 0 and id_before < child_count:
		get_children()[id_before].modulate = Color(1,1,1,1.0-alpha)
	
	if working_id < child_count:
		get_children()[working_id].modulate = Color(1,1,1,alpha)

	current_sequence = new_value
