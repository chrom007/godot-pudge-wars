extends Node

func _ready():
	Network.connect("change_ping", self, "redraw_ping");
	Network.connect("change_players", self, "change_players");

	redraw_players(Network.players);

func redraw_ping(ping):
	$Control/Ping.text = "Ping: " + str(ping);

func redraw_players(players):
	$Control/Players.clear();
	$Control/Online.text = "Online: " + str(players.size());
	for id in players:
		$Control/Players.add_item(players[id]);

func change_players(players, nick, id, join):
	redraw_players(players);
