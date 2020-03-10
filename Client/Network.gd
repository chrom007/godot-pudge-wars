extends Node

signal menu_msg;
signal change_players;
signal change_ping;

var host : NetworkedMultiplayerENet = null;
var nick = null;
var connected = false;
var players = {};
var pong_time = 0;

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

puppet func hello(game_status, _players):
	if (!game_status):
		players = _players;
		emit_signal("menu_msg", "Game ready to play\nWaiting opponents");
		rpc_id(1, "join_game", nick);
		connected = true;
	else:
		emit_signal("menu_msg", "Game is already started!");
		host.close_connection();

puppet func game_start(_players):
	players = _players;
	emit_signal("menu_msg", "Game started\nLoading world...");
	get_tree().change_scene("res://Scenes/World.tscn");

puppet func player_connect(count):
	emit_signal("menu_msg", str("Players on server: ", count));

puppet func player_join(id, nick):
	players[id] = nick;
	emit_signal("change_players", players, id, nick, true);

puppet func player_disconnect(id):
	var nick = players[id];
	players.erase(id);
	emit_signal("change_players", players, id, nick, false);

func ping():
	rpc_id(1, "ping");
	pong_time = OS.get_ticks_msec();
	yield(get_tree().create_timer(1.0), "timeout");
	ping();

puppet func pong():
	var _ping = OS.get_ticks_msec() - pong_time;
	emit_signal("change_ping", _ping);
