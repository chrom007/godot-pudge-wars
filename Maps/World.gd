extends Spatial

const CAM_FOV_MAX = 90;
const CAM_FOV_MIN = 30;
const CAM_MARGIN = 30;
const CAM_SPEED = 10;
const RAY_LENGTH = 100;

var cam_fov_lerp = 0;
var cam_fov = 70;
var cam_inter = Vector3(0, 0, 0);
var cam_inter_lerp = 0;

func _ready():
	OS.window_fullscreen = false;
	pass;


func _process(delta):
	move_camera(delta);

	if (Input.is_action_just_pressed("ui_cancel")):
		OS.window_fullscreen = !OS.window_fullscreen;

	if ($Camera.fov != cam_fov):
		cam_fov = clamp(cam_fov, CAM_FOV_MIN, CAM_FOV_MAX);
		$Camera.fov = lerp($Camera.fov, cam_fov, cam_fov_lerp);
		cam_fov_lerp += 0.0025;


func _input(event):
	if (event is InputEventMouseButton):
		if (event.button_index == BUTTON_RIGHT and event.pressed):
			var mouse = get_viewport().get_mouse_position();
			var ray_start = $Camera.project_ray_origin(mouse);
			var ray_end = ray_start + $Camera.project_ray_normal(mouse) * RAY_LENGTH;
			var target = get_world().direct_space_state.intersect_ray(ray_start, ray_end, [], 1);

			if (target):
				$Human.move_to(target.position);

		if (event.button_index == BUTTON_WHEEL_DOWN):
			cam_fov += 1;
			cam_fov_lerp = 0;
		if (event.button_index == BUTTON_WHEEL_UP):
			cam_fov -= 1;
			cam_fov_lerp = 0;


func move_camera(delta):
	var mouse = get_viewport().get_mouse_position();
	var screen = get_viewport().size;
	var move = Vector3();

	if (mouse.x < CAM_MARGIN):
		move.x -= 1;
	if (mouse.x > screen.x - CAM_MARGIN):
		move.x += 1;
	if (mouse.y < CAM_MARGIN):
		move.z -= 1;
	if (mouse.y > screen.y - CAM_MARGIN):
		move.z += 1;

	if (move.z or move.x):
		cam_inter = move * delta * CAM_SPEED;
		cam_inter_lerp = 0;

	if (cam_inter != Vector3.ZERO):
		cam_inter = cam_inter.linear_interpolate(Vector3(0,0,0), cam_inter_lerp);
		$Camera.global_translate(cam_inter);
		cam_inter_lerp += 0.005;
