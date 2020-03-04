extends KinematicBody

var delta_tick = 0;

const MAX_SPEED = 100;
const ROT_SPEED = 0.1;
const HOOK_MAX_SPEED = 5;

var target = Vector3();
var current_dir = Vector3();
var velocity = Vector3();
var move = false;
var hook_throw = false;

func move_to(_target):
	target = _target;
	move = true;

func _physics_process(delta):
	delta_tick += delta;

	if (delta_tick >= Network.tickrate):
		delta_tick = 0;

		if (move): update_position();

	if (move):
		var target_trans = transform.looking_at(target, Vector3.UP);
		var quat = Quat(transform.basis).slerp(target_trans.basis, ROT_SPEED);
		transform = Transform(quat, transform.origin);
		current_dir = quat.get_euler();

		var forward = -global_transform.basis.z;
		velocity = forward * MAX_SPEED * delta;
		move_and_slide(velocity, Vector3.UP);

		if (transform.origin.distance_to(target) < 0.175):
			target = Vector3();
			velocity = Vector3();
			rpc("animation", "idle");
			move = false;


func update_position():
	rpc_unreliable("update_position", transform.origin, rotation_degrees);
	pass;
