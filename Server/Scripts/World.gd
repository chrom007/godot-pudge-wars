extends Node

func _ready():
	Network.connect("player_disconnect", self, "human_remove");

	for id in Network.players:
		var player = preload("res://Objects/Human.tscn").instance();
		player.set_network_master(1);
		player.set_name(String(id));
		$Players.add_child(player);

remote func human_move(_position):
	var id = get_tree().get_rpc_sender_id();
	get_node("/root/World/Players/" + String(id)).move_to(_position);

func human_remove(id):
	get_node("/root/World/Players/" + String(id)).queue_free();
