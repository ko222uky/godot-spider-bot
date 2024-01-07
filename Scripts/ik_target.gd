extends Marker3D

@export var step_target: Node3D
@export var adjacent_leg: Node3D
@export var opposite_leg: Node3D


var is_stepping : bool = false

## How far the model can travel until the IK targets update to new positions.
@export var step_distance: float = 3.0 

func _process(delta):
	# we call step() if our current node is NOT stepping AND if our adjacent node is NOT stepping
	if !is_stepping && !adjacent_leg.is_stepping && abs(global_position.distance_to(step_target.global_position)) > step_distance:
		step()
		opposite_leg.step() # the leg diagonally opposite from this leg will also step


func step():
	var target_pos = step_target.global_position # this stores the global position of our step targets
	var half_way = (global_position + step_target.global_position) / 2 # calculated a halfway position, using IK target position and step target position
	
	is_stepping = true # is_stepping set to true 
	
	var t = get_tree().create_tween()
	t.tween_property(self, "global_position", half_way + owner.basis.y, 0.1) # the owner.basis.y returns local-y, which is 1 meter up in whichever direction the bot is currently oriented
	t.tween_property(self, "global_position", target_pos, 0.1)
	t.tween_callback(func(): is_stepping = false) # after tweening, we use callback() and then a lambda function to set is_stepping back to false
