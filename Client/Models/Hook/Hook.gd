extends Spatial

const HOOK_SPEED = 7;
const RANGE_MAX = 6;

var speed = 0;
var move = false;

func _physics_process(delta):
	if (move):
		$Body.transform.origin.x += speed * delta;

#		if ($Body.transform.origin.x > RANGE_MAX):
#			speed = -HOOK_SPEED;

		if ($Body.transform.origin.x <= 0.35):
			stop_move();

		var w = $Body.transform.origin.x * 2000;
		$Chains.region_rect = Rect2(0, 0, w, 150);

puppet func hook_cameback(_transform):
	$Body.transform.origin.x = _transform;
	speed = -HOOK_SPEED;

func start_move():
	$TimerStart.one_shot = true;
	$TimerStart.wait_time = 0.5;
	$TimerStart.start(0.5);

func stop_move(with_timer = false):
	if (with_timer):
		$TimerStart.stop();
	speed = 0;
	move = false;
	$Chains.hide();
	get_parent().call("hook_back");
	$Body.transform.origin.x = 0.35;


func _on_TimerStart_timeout():
	move = true;
	speed = HOOK_SPEED;
	get_parent().call("hook_forward");
	$Chains.show();
