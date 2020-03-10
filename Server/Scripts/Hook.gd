extends Spatial

const HOOK_SPEED = 5;
const RANGE_MAX = 5;

var speed = 0;
var move = false;
var stick : KinematicBody = null;

func _physics_process(delta):
	if (stick):
		stick.transform.origin.x = $Body.global_transform.origin.x;
		stick.transform.origin.z = $Body.global_transform.origin.z;
		stick.update_position(true);

	if (move):
		$Body.transform.origin.x += speed * delta;

		if ($Body.transform.origin.x > RANGE_MAX):
			speed = -HOOK_SPEED;
			rpc("hook_cameback", $Body.transform.origin.x);

		if ($Body.transform.origin.x <= 0.35):
			speed = 0;
			stick = null;
			move = false;
			get_parent().call("hook_back");
			$Body.transform.origin.x = 0.35;

func start_move():
	$TimerStart.one_shot = true;
	$TimerStart.wait_time = 0.5;
	$TimerStart.start(0.5);

#func back_move():
#	speed = -HOOK_SPEED;

func _on_TimerStart_timeout():
	move = true;
	speed = HOOK_SPEED;

func _on_Body_entered(body):
	if (move and body.is_in_group("humans")):
		speed = -HOOK_SPEED;
		rpc("hook_cameback", $Body.transform.origin.x);
		stick = get_node("/root/World/Players/" + body.name);
