extends KinematicBody

var velocity = Vector3();
var target = Vector3();
#var hook_throw = false;

func _ready():
	#Network.connect()
	pass;

func _physics_process(delta):
	if (velocity != Vector3.ZERO):
		velocity = move_and_slide(velocity, Vector3.UP);
		if ($AnimationPlayer.current_animation != "Run"):
			animation_play("run");

	if (Input.is_key_pressed(KEY_SPACE)):
		rpc_id(1, "hook");

func hook_forward():
	$Hook.show();
	$Skeleton/Hand/HandHook.hide();

func hook_back():
	#hook_throw = false;
	$Hook.hide();
	$Skeleton/Hand/HandHook.show();

puppet func hook_throw_start():
	animation_play("hook");
	$Hook.start_move();

puppet func anim(anim_name):
	animation_play(anim_name);

puppet func set_target(_target):
	target = _target;

puppet func update_position(_transform, _rotation, _velocity, force = false):
	if ((transform.origin.distance_to(target) * 0.85 > _transform.distance_to(target)) or force):
		transform.origin = _transform;
	rotation_degrees = _rotation;
	velocity = _velocity;

func animation_play(anim_name):
	match anim_name:
		"idle":
			$AnimationPlayer.play("Idle", 0.2, 1);
		"run":
			$AnimationPlayer.play("Run", 0.15, 2);
		"hook":
			$AnimationPlayer.play("Hook", 0.15, 1);


