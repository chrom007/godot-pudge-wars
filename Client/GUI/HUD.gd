extends Node

func _ready():
	Network.connect("change_ping", self, "redraw_ping");
	Network.connect("change_players", self, "redraw_players");

	redraw_players(Network.players);

func redraw_ping(ping):
	$Ping.text = "Ping: " + str(ping);

func redraw_players(players):
	$Players.clear();
	$Online.text = "Online: " + str(players.size());
	for id in players:
		$Players.add_item(players[id]);
