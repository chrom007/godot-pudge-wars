extends KinematicBody

const MAX_SPEED = 100;
const ROT_SPEED = 0.1;
const HOOK_MAX_SPEED = 5;

var target = Vector3();
var current_dir = Vector3();
var velocity = Vector3();
var move = false;
var hook_throw = false;
var hook_speed = 0;

func _ready():
	$AnimationPlayer.current_animation = "Idle";
	$AnimationPlayer.play();

func move_to(_target):
	if (!hook_throw):
		move = true;
		target = _target;
		$AnimationPlayer.play("Run", 0.2, 2);

func _physics_process(delta):
	#Engine.target_fps = 60
	#print(delta, " | ", Engine.get_frames_per_second(), $Skeleton/Hand.transform.origin);
	if (transform.origin.distance_to(target) < 0.175 and move):
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

	if (Input.is_key_pressed(KEY_SPACE) and !hook_throw):
		hook_throw = true;
		move = false;
		$AnimationPlayer.play("Hook", 0.2, 1);
		$Hook.start_move();

func hook_forward():
	$Hook.show();
	$Skeleton/Hand/HandHook.hide();

func hook_back():
	hook_throw = false;
	$Hook.hide();
	$Skeleton/Hand/HandHook.show();
	$AnimationPlayer.play("Idle", 0.15, 1);
