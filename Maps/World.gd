extends Spatial

const CAM_MAX = 30;
const CAM_SPEED = 10;
var cam_inter = Vector3();

onready var camera : Camera = $Camera;

func _ready():
	#OS.window_fullscreen = true;
	pass;

func _process(delta):
	var mouse = get_viewport().get_mouse_position();
	var screen = get_viewport().size;
	var move = Vector3();

	if (mouse.x < CAM_MAX):
		move.x -= 1;
	if (mouse.x > screen.x - CAM_MAX):
		move.x += 1;
	if (mouse.y < CAM_MAX):
		move.z -= 1;
	if (mouse.y > screen.y - CAM_MAX):
		move.z += 1;

	if (move.z or move.x):
		cam_inter = move * delta * CAM_SPEED;

	if (cam_inter != Vector3.ZERO):
		cam_inter = cam_inter.linear_interpolate(Vector3(0,0,0), 0.1);
		camera.global_translate(cam_inter);
		print(cam_inter, Vector3.ZERO);
