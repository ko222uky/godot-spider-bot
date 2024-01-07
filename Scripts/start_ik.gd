# We add @tool to the script, so that the IK can run in the editor, too
@tool


extends SkeletonIK3D


# Called when the node enters the scene tree for the first time.
func _ready():
	start()

