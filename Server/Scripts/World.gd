extends Node

func _ready():
	for id in Network.players:
		var player = preload("res://Objects/Human.tscn").instance();
		player.set_network_master(id);
		player.set_name(String(id));
		$Players.add_child(player);

remote func move_to(pos):
	var id = get_tree().get_rpc_sender_id();
	print("Move {", id, "} to: ", pos);
