extends KinematicBody

var velocity = Vector3();
var target = Vector3();

var nick_size = Vector2(160, 40);
var nick_texture = null;
var nick = "";

func _ready():
	#Network.connect()
	draw_nick(nick);
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
	if ((transform.origin.distance_to(_transform) > 0.1) or force):
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

func set_nick(_nick):
	nick = _nick;

func draw_nick(_nick):
	var vport = Viewport.new();
	var font : DynamicFont = load("res://Assets/opensans.tres");

	vport.transparent_bg = true;
	vport.size = nick_size
	vport.render_target_update_mode = Viewport.UPDATE_ALWAYS;
	add_child(vport)

	var label : Label = Label.new();
	label.text = _nick;
	label.valign = Label.VALIGN_CENTER;
	label.align = Label.ALIGN_CENTER;
	label.rect_size = nick_size;
	label.add_color_override("font_color", Color(10, 10, 10));
	label.add_font_override("font", font);
	vport.add_child(label);
	yield(get_tree().create_timer(0.1), "timeout");

	var image = vport.get_texture().get_data();
	image.flip_y();
	#image.save_png("res://test.png");
	nick_texture = ImageTexture.new();
	nick_texture.create_from_image(image);
	$Nick.texture = nick_texture;

	vport.queue_free();
