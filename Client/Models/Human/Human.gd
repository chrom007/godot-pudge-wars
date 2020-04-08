extends KinematicBody

var velocity = Vector3();
var target = Vector3();
var is_local = false;

var nick_size = Vector2(160, 40);
var nick_texture = null;
var nick = "";
var hp = 0;
var dead = false;
var cam: Camera = null;

func _ready():
	#Network.connect()
	cam = get_node("/root/World/Camera");
	is_local = (int(name) == get_tree().get_network_unique_id());
	draw_nick(nick);

func _physics_process(delta):
	update_hud();

	if (velocity != Vector3.ZERO):
		velocity = move_and_slide(velocity, Vector3.UP);
		if ($AnimationPlayer.current_animation != "Run"):
			animation_play("run");

	if (Input.is_action_just_released("hook") and is_local):
		rpc_id(1, "hook");
		$Line.hide();

	if (Input.is_action_just_pressed("hook") and is_local and !dead):
		$Line.show();

	if (Input.is_action_just_released("stop") and is_local):
		rpc_id(1, "stop");

#	if (dead and $AnimationPlayer.current_animation != "Dead"):
#		print("STOP, DIE", $AnimationPlayer.current_animation);
#		animation_play("dead");

func hook_forward():
	$Hook.show();
	$Skeleton/Hand/HandHook.hide();

func hook_back():
	$Hook.hide();
	$Skeleton/Hand/HandHook.show();

puppet func hook_moving_start():
	animation_play("hook");
	$Hook.start_move();

puppet func hook_moving_stop():
	animation_play("idle");
	$Hook.stop_move(true);

puppet func anim(anim_name):
	if (!dead):
		animation_play(anim_name);

puppet func die():
	hp = 0;
	dead = true;
	velocity = Vector3();
	target = Vector3();
	animation_play("dead");
#	yield(get_tree().create_timer(0.1), "timeout");
#	animation_play("dead");

puppet func change_hp(_hp):
	hp = _hp;
	$HUD_rotator/HumanHUD/Viewport/Bar.value = hp;

puppet func set_target(_target):
	target = _target;

puppet func update_position(_transform, _rotation, _velocity, force = false):
	if ((transform.origin.distance_to(_transform) > 0.1) or force):
		transform.origin = _transform;
	rotation_degrees = _rotation;
	velocity = _velocity;
	update_hud();

func update_hud():
	var look = cam.transform.origin;
	look.x = transform.origin.x;
	$HUD_rotator.look_at(look, Vector3.UP);
	$HUD_rotator.rotation_degrees.y += 180;
	$HUD_rotator.rotation_degrees.x *= -1;

func animation_play(anim_name):
	match anim_name:
		"idle":
			$AnimationPlayer.play("Idle", 0.2, 1);
		"run":
			$AnimationPlayer.play("Run", 0.15, 2);
		"hook":
			$AnimationPlayer.play("Hook", 0.15, 1);
		"dead":
			$AnimationPlayer.play("Dead", 0.15, 1);





func set_nick(_nick):
	nick = _nick;

func draw_nick(_nick):
	$HUD_rotator/HumanHUD/Viewport/Nick.text = _nick;
	$HUD_rotator/HumanHUD/Viewport/Nick.add_color_override("font_color", Color(10, 10, 10));
