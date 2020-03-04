extends Node

signal menu_msg;
signal change_players;
signal player_disconnect;

var host : NetworkedMultiplayerENet = null;
var nick = null;
var connected = false;
var players = {};

func _ready():
	pass;

func client_connect(ip, port, nickname):
	nick = nickname;
	host = NetworkedMultiplayerENet.new();
	var err = host.create_client(ip, port);
	if (err != OK):
		host = null;
		emit_signal("menu_msg", "Connection failed!");
		return print("Connection error");
	get_tree().set_network_peer(host);
	print("Client connected");

puppet func hello(game_status):
	if (!game_status):
		emit_signal("menu_msg", "Game ready to play\nWaiting opponents");
		rpc_id(1, "join_game", nick);
		connected = true;
	else:
		emit_signal("menu_msg", "Game is already started!");
		host.close_connection();

puppet func game_start(_players):
	players = _players;
	emit_signal("menu_msg", "Game started\nLoading world...");
	get_tree().change_scene("res://Maps/World.tscn");

puppet func player_online(count):
	emit_signal("menu_msg", str("Players on server: ", count));

puppet func player_disconnect(id):
	emit_signal("player_disconnect", id);
