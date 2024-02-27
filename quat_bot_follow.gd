
extends Node3D
## Node3D that the QuatBot will look at
@export var player: Node3D
## QuatBot's turning speed. Unitless parameter.
@export var turn_speed: float = 1.00
## Angle of detection, in degrees, with respect to this node's Z-axis. If direction to a target makes an angle with this node's Z-axis that is less than this amount, this node can "see" the target.
@export var detection_angle: float = 45
## How fast the see_bot moves towards the target
@export var MOVE_SPEED: float = 0.5
## If target is within this distance, in meters, this node can "see" target and will chase target.
@export var detection_distance: float = 10
## If target is within this distance, in meters, this node can "see" target but will not chase
@export var see_distance: float = 30



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	# Basis method; first, compute new basis
	var player_direction_z = (transform.origin - player.transform.origin) # Vector3D pointing to the player, which will be our Z-component for our basis
	var player_direction_x = transform.basis.y.cross(player_direction_z) # Cross our calculated Z-component with quat bot's local Y-basis
	var player_direction_y = transform.basis.y # This is simply our Y-basis of the quat bot; THUS, Y-COMPONENT IS LOCKED TO STARTING TRANSFORM.BASIS.Y
	# Instantiate new basis with our individually computed Vector3D's. 
	# It must be orthonormalized(), or errors will occurr
	var player_direction_basis = Basis(player_direction_x, player_direction_y, player_direction_z).orthonormalized()

	var target_cos_theta = player_direction_z.normalized().dot(transform.basis.z.normalized())	
	
	
	
	if target_cos_theta > cos(deg_to_rad(detection_angle)) && global_position.distance_to(player.global_position) < detection_distance:
		transform.origin = lerp(transform.origin, player.transform.origin, MOVE_SPEED * _delta)
		#print("I see you!")

	if global_position.distance_to(player.global_position) < see_distance:
		# Also orthonormalize() to correct for floating point precision error
		transform.basis = lerp(transform.basis, player_direction_basis, turn_speed * _delta).orthonormalized()
		

	# Quaternion method; same result, since we instantiate a quaternion with our computed basis
	#var a = Quaternion(transform.basis) # pass as argument a basis representing 'from'
	#var b = Quaternion(player_direction_basis) # pass as argument a basis representing 'to'
	#var c = a.slerp(b, turn_speed * _delta) # interpolate from 'from' to 'to'
	#transform.basis = Basis(c)
	



	




	

