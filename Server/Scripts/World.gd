extends Node

func _ready():
	Network.connect("player_disconnect", self, "human_remove");

	for id in Network.players:
		var player = preload("res://Objects/Human.tscn").instance();
		#player.set_network_master(1);
		player.set_name(String(id));
		var xx = rand_range(-9, 9);
		var zz = rand_range(-9, 9);
		player.transform.origin = Vector3(xx, 0, zz);
		$Players.add_child(player);

	yield(get_tree().create_timer(0.2), "timeout");
	var players = $Players.get_children();

	for player in players:
		player.update_position(true);

remote func human_move(_position):
	var id = get_tree().get_rpc_sender_id();
	get_node("/root/World/Players/" + String(id)).move_to(_position);

func human_remove(id):
	get_node("/root/World/Players/" + String(id)).queue_free();
