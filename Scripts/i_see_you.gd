extends Node3D
## The target which will be "seen" by this node.
@export var target: Node3D

## Angle of detection, in degrees, with respect to this node's Z-axis. If direction to a target makes an angle with this node's Z-axis that is less than this amount, this node can "see" the target.
@export var detection_angle: float = 45

## How fast the see_bot moves towards the target
@export var MOVE_SPEED: float = 0.5
## If target is within this distance, in meters, this node can "see" target.
@export var detection_distance: float = 10

## If the bot gets any closer than this, it stops moving toward its target.
@export var follow_distance: float = 1
# To prevent the spamming of print messages.
var timer: float = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	
	# direction from self to target can be found by vector subtraction
	var target_direction = target.transform.origin - transform.origin 
	
	# Take dot product of this direction and self's forward direction
	# A dot B = cos(theta)
	# cos(theta) is target_angle, where theta is in RADIANS 
	var target_cos_theta = target_direction.normalized().dot(-transform.basis.z.normalized())	


# DON'T USE ANGLES OR RADS, but I'll leave the code here for future reference
	# value of theta, in radians
	#var rotation_rad = acos(target_angle_xz)
	# value of theta, in degreesㅛ
	#var rotation_deg = rad_to_deg(rotation_rad)
	

	if target_cos_theta > cos(deg_to_rad(detection_angle)) && global_position.distance_to(target.global_position) < detection_distance:
		#if timer > 0.5:
			#print("I see you.", " ", target_direction.normalized().dot(-transform.basis.z.normalized()), "  " , cos(deg_to_rad(detection_angle)))
			#timer = 0

		# the simplest way to get see bot to look at target
		#look_at(target.global_position, Vector3.UP)
		
		
		# Start to move our bot to the target, we lerp
		if global_position.distance_to(target.global_position) > follow_distance:
			global_transform.origin = lerp(global_transform.origin, target.global_transform.origin, MOVE_SPEED * delta)

	else:
		pass
		#if timer > 0.5:
			#print("I don't see you.", " ", target_direction.normalized().dot(-transform.basis.z.normalized()), "  " , cos(deg_to_rad(detection_angle)))
			#timer = 0


	

