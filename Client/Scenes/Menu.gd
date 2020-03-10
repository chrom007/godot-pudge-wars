extends Node

const REMOTE_IP = "185.159.130.41";
onready var console: Label = $Panel/Console;
var saved_ip = "127.0.0.1";

func _ready():
	$Connect.connect("pressed", self, "connect_pressed");
	$Remote.connect("toggled", self, "remote_toggled");
	Network.connect("menu_msg", self, "menu_msg");
	Network.connect("change_players", self, "change_players");

func connect_pressed():
	var ip = $IP.text;
	var nickname = $Nickname.text;
	if (!ip or !nickname):
		return menu_msg("Not all field has filled");
	$Connect.disabled = true;
	Network.client_connect(ip, 6464, nickname);

func remote_toggled(toggled):
	if (toggled):
		saved_ip = $IP.text;
		$IP.text = REMOTE_IP;
		$IP.editable = false;
		menu_msg("Server changed to global");
	else:
		$IP.text = saved_ip;
		$IP.editable = true;
		menu_msg("Server changed to custom");

func change_players(players, id, nick, join):
	var status = "connected" if join else "disconnected";
	menu_msg("Player " + nick + " has " + status);

func menu_msg(msg):
	console.text += msg + "\n";
	console.scroll_to_line(console.get_line_count() - 1);
