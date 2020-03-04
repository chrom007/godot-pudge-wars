extends KinematicBody

func _ready():
	#Network.connect()
	pass;

puppet func update_position(_transform, _rotation):
	transform.origin = _transform;
	rotation_degrees = _rotation;
	print("update_position", _transform, _rotation);
	pass;
