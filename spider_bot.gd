extends Node3D

@export var move_speed: float = 5.0
@export var turn_speed: float = 1.0

## Desired height offset from the ground
@export var ground_offset: float = 0.5

# We use global positions of IK targets to instantiate a plane
@onready var fl_leg: Marker3D = $FrontLeftIKTarget
@onready var fr_leg: Marker3D = $FrontRightIKTarget

@onready var bl_leg: Marker3D = $BackLeftIKTarget
@onready var br_leg: Marker3D = $BackRightIKTarget




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var plane1 = Plane(bl_leg.global_position, fl_leg.global_position, fr_leg.global_position) # our first plane, initialized with IK target positions, in clockwise order
	var plane2 = Plane(fr_leg.global_position, br_leg.global_position, bl_leg. global_position)
	
	# Thus, our spider body will have two planes, each with a normal. We then find the average of these two normals
	# the normal should also be normalized, since we're doing vector addition. (recall pythagorean theorem)
	var avg_normal = ((plane1.normal + plane2.normal) / 2).normalized()
	
	# pass our normal to our written function
	var target_basis = _basis_from_normal(avg_normal)
	# Next, we use our newly calculated basis to overwrite our current basis for the spider bot
	# lerp adds an interpolation to make the movement smooth
	transform.basis = lerp(transform.basis, target_basis, move_speed * _delta).orthonormalized()
	
	# average positions of legs
	var avg = (fl_leg.position + fr_leg.position + bl_leg.position + br_leg.position) / 4
	
	# target position, which is our current transform.basis.y PLUS avg leg position, weighted by the ground offset
	var target_pos = avg + transform.basis.y *  ground_offset
	
	# dot products return a scalar
	var distance = transform.basis.y.dot(target_pos - position)
	#print(target_pos - avg, " ", distance, " ", transform.basis.y)
	
		# since dot product gave us only the magnitude of our distance, we multiply this in the lerp() by transform.basis.y to re-add the directional component
	position = lerp(position, position + transform.basis.y * distance, move_speed * _delta)	
	
	_handle_movement(_delta)

func _handle_movement(_delta):
	var dir = Input.get_axis('ui_up', 'ui_down') # For keyboard inputs, .get_axis() returns a Boolean, first argument is the negative_action, second is the positive_action
	translate(Vector3(0, 0, dir) * move_speed * _delta)
		
	var a_dir = Input.get_axis('ui_right', 'ui_left') # ui_right is negative, ui_left is positive
	rotate_object_local(Vector3.UP, a_dir * turn_speed * _delta) # rotate around object's local y-axis, regardless of it global orientation.
		# thus, correct rotational movement is achieved if our objecting is standing on a wall, or is upside down.
		# note: the rotational axis, which is the first argument above, is the object's local axis.

func _basis_from_normal(normal: Vector3):
	var result = Basis()
	# Cross products outputs a vector perpendicular to the inputs; consult local gizmo to understand the reasoning here
	result.x = normal.cross(transform.basis.z)
	result.y = normal # since our normal, perpendicular to our plane, points up
	result.z = transform.basis.x.cross(normal)

	
	# orthonormalize the result and scale it
	result = result.orthonormalized()
	result.x *= scale.x
	result.y *= scale.y
	result.z *= scale.z
	
	return result
	


	
