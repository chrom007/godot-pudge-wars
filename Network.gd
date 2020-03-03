extends Node

signal menu_msg;
signal change_players;

var host : NetworkedMultiplayerENet = null;
var nick = null;
var connected = false;

func _ready():
	pass;

func client_connect(ip, port, nickname):
	nick = nickname;
	host = NetworkedMultiplayerENet.new();
	var err = host.create_client(ip, port);
	if (err): return print("Connection error: ", err);
	get_tree().set_network_peer(host);
	print("Client connected");

puppet func hello(game_status):
	if (!game_status):
		emit_signal("menu_msg", "Game ready to play\nWaiting opponents\n");
		rpc_id(1, "join_game", nick);
		connected = true;
	else:
		emit_signal("menu_msg", "Game is already started!\n");
		host.close_connection();

puppet func game_start():
	emit_signal("menu_msg", "Game started\nLoading world...\n");
	get_tree().change_scene("res://Maps/World.tscn");

puppet func player_online(count):
	emit_signal("menu_msg", str("Players on server: ", count, " \n"));
	pass;

puppet func player_transform(id, _transform):
	#get_tree().get_
	print("player_transform", id, _transform);
	pass;
