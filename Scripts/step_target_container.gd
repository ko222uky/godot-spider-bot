extends Node3D

# Fixes the legs' dragging behind when moving forwards and backwards

@export var offset: float = 250 # Be sure to set an offset that's high enough to fix leg drag
@onready var parent = get_parent_node_3d()
@onready var previous_position = parent.global_position # onready, store parent's global position.

func _process(delta):
	var velocity = parent.global_position - previous_position # take the current position and subtract from it the parent's position from the last frame

	global_position = parent.global_position + velocity * offset # update our step container's position in this frame
	
	previous_position = parent.global_position # update the previous position variable for the next frame

