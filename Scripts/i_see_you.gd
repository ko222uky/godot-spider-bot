extends Node3D
## The target which will be "seen" by this node.
@export var target: Node3D
## Angle of detection, in degrees, with respect to this node's Z-axis. If direction to a target makes an angle with this node's Z-axis that is less than this amount, this node can "see" the target.
@export var detection_angle: float = 45
## How fast the see_bot moves towards the target
@export var MOVE_SPEED: float = 0.5
## How fast the see_bot can turn
@export var TURN_SPEED: float = 1.0
## If target is within this distance, in meters, this node will chase the target.
@export var detection_distance: float = 10
## Range within which our SeeBot will start to look at the target
@export var sight_range: float = 30
## If the bot gets any closer than this, it stops moving toward its target.
@export var follow_distance: float = 1
# To prevent the spamming of print messages.
var timer: float = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	
# Compute new basis for rotational movemebnts
	var target_direction = transform.origin - target.transform.origin # our Z-component for our basis
	var player_direction_x = transform.basis.y.cross(target_direction) # Cross our calculated Z-component with quat bot's local Y-basis
	var player_direction_y = transform.basis.y # This is simply our Y-basis of the quat bot; THUS, Y-COMPONENT IS LOCKED TO STARTING TRANSFORM.BASIS.Y
	var target_basis = Basis(player_direction_x, player_direction_y,target_direction).orthonormalized()
	
# Compute angle for detecting player
	# Take dot product of this direction and self's forward direction
	# A dot B = cos(theta)
	# cos(theta) is target_angle, where theta is in RADIANS 
	var target_cos_theta = target_direction.normalized().dot(transform.basis.z.normalized())	
	
	#print(target_cos_theta, "  " , cos(deg_to_rad(detection_angle)))
	
# Distance within which our SeeBot will begin to turn towards the player but not move towards the player
	if global_position.distance_to(target.global_position) < sight_range:
		transform.basis = lerp(transform.basis, target_basis, TURN_SPEED * delta).orthonormalized()

# Initiate movement if the target falls within detection_distance AND falls within detection angles
	if target_cos_theta > cos(deg_to_rad(detection_angle)) && global_position.distance_to(target.global_position) < detection_distance:
		#if timer > 0.5:
			#print("I see you.") 
			#timer = 0
				
		# Start to move our bot to the target, we lerp. We won't go closer than the follow_distance
		if global_position.distance_to(target.global_position) > follow_distance:
			transform.origin = lerp(transform.origin, target.transform.origin, MOVE_SPEED * delta)

	else:
		pass
		#if timer > 1:
			#print("I don't see you.") #, " ", target_direction.normalized().dot(-transform.basis.z.normalized()), "  " , cos(deg_to_rad(detection_angle)))
			#timer = 0


	
# DON'T USE ANGLES OR RADS, but I'll leave the code here for future reference
	# value of theta, in radians
	#var rotation_rad = acos(target_angle_xz)
	# value of theta, in degreesㅛ
	#var rotation_deg = rad_to_deg(rotation_rad)
