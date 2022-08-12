extends Node2D

const PlayerScene = preload("res://Player.tscn")

@onready var networked_nodes = $NetworkedNodes
@onready var spawner: MultiplayerSpawner = $MultiplayerSpawner

# Called when the node enters the scene tree for the first time.
func _ready():
	spawner.spawned.connect(func (x): print(x))
	print(spawner._spawnable_scenes)
	print(OS.get_cmdline_args())
	if "--server" in OS.get_cmdline_args():
		start_network(true)
	else:
		start_network(false)

func start_network(is_server: bool):
	var peer = ENetMultiplayerPeer.new()
	if is_server:
		multiplayer.peer_connected.connect(self.create_player)
		multiplayer.peer_disconnected.connect(self.destroy_player)
		peer.create_server(4242)
		print("server listening on localhost 4242")
	else:
		var target_ip = "localhost"
		peer.create_client(target_ip, 4242)
	multiplayer.multiplayer_peer = peer
		

func create_player(id):
	print("connect")
	var p = PlayerScene.instantiate()
	p.name = str(id)
	networked_nodes.add_child(p)


func destroy_player(id):
	networked_nodes.get_node(str(id)).queue_free()


