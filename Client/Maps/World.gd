extends Spatial

const CAM_FOV_MAX = 90;
const CAM_FOV_MIN = 25;
const CAM_MARGIN = 30;
const CAM_SPEED = 10;
const RAY_LENGTH = 100;

var cam_fov_lerp = 0;
var cam_fov = 70;
var cam_inter = Vector3(0, 0, 0);
var cam_inter_lerp = 0;

func human_remove(id):
	get_node("/root/World/Players/" + String(id)).queue_free();

func _ready():
	#OS.window_fullscreen = false;
	Network.connect("player_disconnect", self, "human_remove");

	for id in Network.players:
		var player : KinematicBody = load("res://Models/Human.tscn").instance();
		player.set_network_master(1);
		player.set_name(String(id));
		$Players.add_child(player);


func _process(delta):
	move_camera(delta);

	if (Input.is_action_just_pressed("ui_cancel")):
		OS.window_fullscreen = !OS.window_fullscreen;

	if (Input.is_key_pressed(KEY_F1)):
		var myid = String(Network.host.get_unique_id());
		$Camera.transform.origin.x = $Players.get_node(myid).transform.origin.x;
		$Camera.transform.origin.z = $Players.get_node(myid).transform.origin.z + 6;

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
				if (Network.connected):
					var myid = Network.host.get_unique_id();
					get_node("/root/World/Players/" + String(myid)).target = target.position;
					$Target.transform.origin = target.position;
					$Target/AnimationPlayer.play("Anim", 0, 2);
					$Target/AnimationPlayer.seek(0, true);
					return rpc_id(1, "human_move", target.position);

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
