extends Node

onready var console: Label = $Panel/Console;

func _ready():
	$Connect.connect("pressed", self, "connect_pressed");
	Network.connect("menu_msg", self, "menu_msg");
	Network.connect("change_players", self, "change_players");

func connect_pressed():
	$Connect.disabled = true;
	var nickname = $Nickname.text;
	Network.client_connect("127.0.0.1", 6464, nickname);

func menu_msg(msg):
	console.text += msg;
