extends Node3D

@export var target: Node3D

## Offset for target's height for corrections, if needed.
@export var height_offset: float = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	# An even simpler method, wherein you only need to provide a target position and rotational axis
	# NO AXIS LOCK
	look_at(target.global_position + Vector3(0,height_offset,0), Vector3(0, 1, 0))

