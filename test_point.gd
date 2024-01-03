extends Node3D

@export var target: Node3D

## Offset for target's height for corrections, if needed.
@export var height_offset: float = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# The next line obtains the target direction, which is a vector drawn from self node to target node 
	#var target_dir = (target.global_transform.origin - global_transform.origin).normalized()
	
	# The next line applies a transformation to self node
	#global_transform.basis = Basis(Vector3(0, 0, 0), Vector3(0, 0, 0), target_dir)
	
	# An even simpler method, wherein you only need to provide a target position and rotational axis
	look_at(target.global_position + Vector3(0,height_offset,0))

