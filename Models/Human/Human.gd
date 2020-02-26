extends KinematicBody

const MAX_SPEED = 100;
const ROT_SPEED = 0.1;

var target = Vector3();
var current_dir = Vector3();
var velocity = Vector3();
var move = false;

func _ready():
	$AnimationPlayer.current_animation = "Idle";
	$AnimationPlayer.play();

func move_to(_target):
	move = true;
	target = _target;

	$AnimationPlayer.play("Run", 0.2, 2);

func _physics_process(delta):
	if (transform.origin.distance_to(target) < 0.15):
		target = Vector3();
		velocity = Vector3();
		$AnimationPlayer.play("Idle", 0.15, 1);
		move = false;

	if (move):
		var target_trans = transform.looking_at(target, Vector3.UP);
		var quat = Quat(transform.basis).slerp(target_trans.basis, ROT_SPEED);
		transform = Transform(quat, transform.origin);

		var forward = -global_transform.basis.z;
		velocity = forward * MAX_SPEED * delta;
		move_and_slide(velocity, Vector3.UP);
