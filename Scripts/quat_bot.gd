extends Node3D
## Node3D that the QuatBot will look at
@export var player: Node3D
## QuatBot's turning speed. Unitless parameter.
@export var turn_speed: float = 1.00
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	# Basis method; first, compute new basis
	var player_direction_z = (transform.origin - player.transform.origin) # Vector3D pointing to the player, which will be our Z-component for our basis
	var player_direction_x = transform.basis.y.cross(player_direction_z) # Cross our calculated Z-component with quat bot's local Y-basis
	var player_direction_y = transform.basis.y # This is simply our Y-basis of the quat bot; THUS, Y-COMPONENT IS LOCKED TO STARTING TRANSFORM.BASIS.Y
	# Instantiate new basis with our individually computed Vector3D's. 
	# It must be orthonormalized(), or errors will occurr
	var player_direction_basis = Basis(player_direction_x, player_direction_y, player_direction_z).orthonormalized()

	# Also orthonormalize() to correct for floating point precision error
	transform.basis = lerp(transform.basis, player_direction_basis, turn_speed * _delta).orthonormalized()
	

	# Quaternion method; same result, since we instantiate a quaternion with our computed basis
	var a = Quaternion(transform.basis) # from
	var b = Quaternion(player_direction_basis) # to
	var c = a.slerp(b, turn_speed * _delta)
	#transform.basis = Basis(c)
