extends Node

signal player_disconnect;

# 0.0166 - 60 ticks
# 0.0333 - 30 ticks
const tickrate = 0.0333;
const MAX_PLAYERS = 10;
const PORT = 6464;

var host = null;
var players = {};
var game_started = false;

func _ready():
	host = NetworkedMultiplayerENet.new();
	var err = host.create_server(PORT, MAX_PLAYERS);
	if (err): return print("Connection error: ", err);
	get_tree().set_network_peer(host);
	get_tree().connect("network_peer_connected", self, "_player_connected");
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected");
	print("Server started at ", PORT, " port");

func _player_connected(id):
	print("Player ", id, " connected");
	rpc_id(id, "hello", game_started);
	rpc("player_connect", players.size() + 1);

func _player_disconnected(id):
	if (players.has(id)):
		print("Player ", id, " disconnected");
		players.erase(id);
		if (game_started):
			rpc("player_disconnect", id);
			emit_signal("player_disconnect", id);

remote func join_game(nick):
	var id = get_tree().get_rpc_sender_id();
	players[id] = nick;

	if (players.size() >= 2):
		game_started = true;
		print("Game started");
		rpc("game_start", players);
		get_tree().change_scene("res://World.tscn");








