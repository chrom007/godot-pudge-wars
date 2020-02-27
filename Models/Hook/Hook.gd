extends Spatial

const HOOK_SPEED = 5;
const RANGE_MAX = 5;

var speed = 0;
var move = false;

func _physics_process(delta):
	if (move):
		$HookMesh.transform.origin.x += speed * delta;

		if ($HookMesh.transform.origin.x > RANGE_MAX):
			speed = -HOOK_SPEED;

		if ($HookMesh.transform.origin.x <= 0.35):
			speed = 0;
			move = false;
			$Chains.hide();
			get_parent().call("hook_back");

		var w = $HookMesh.transform.origin.x * 2000;
		$Chains.region_rect = Rect2(0, 0, w, 150);

func start_move():
	$TimerStart.one_shot = true;
	$TimerStart.wait_time = 0.5;
	$TimerStart.start(0.5);

func back_move():
	speed = -HOOK_SPEED;

func _on_TimerStart_timeout():
	move = true;
	speed = HOOK_SPEED;
	get_parent().call("hook_forward");
	$Chains.show();
