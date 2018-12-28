extends "custom_multiplayer.gd"

export var in_bandwidth = 0
export var out_bandwidth = 0
export var channels = 2
export(int) var rpc_channel setget set_rpc_channel, get_rpc_channel
export var max_peers = 32

var _peer : NetworkedMultiplayerENet = null

func _init():
	custom_multiplayer = load("benet_multiplayer_api.gd").new()
	custom_multiplayer.set_root_node(self)

func _ready():
	custom_multiplayer.rpc_channel = rpc_channel

func _exit_tree():
	close_connection(0)

func set_rpc_channel(channel : int):
	custom_multiplayer.rpc_channel = channel

func get_rpc_channel() -> int:
	return custom_multiplayer.rpc_channel

func close_connection(wait : int = 100):
	if _peer != null:
		_peer.close_connection(wait)
		_peer = null

func start_server(port : int, bind_ip : String = "*"):
	assert(is_inside_tree())
	assert(_peer == null)
	_peer = NetworkedMultiplayerENet.new()
	_peer.channel_count = channels
	_peer.set_bind_ip(bind_ip)
	_peer.create_server(port, max_peers, in_bandwidth, out_bandwidth)
	custom_multiplayer.network_peer = _peer

func start_client(host : String, port : int):
	assert(is_inside_tree())
	assert(_peer == null)
	_peer = NetworkedMultiplayerENet.new()
	_peer.channel_count = channels
	_peer.create_client(host, port, max_peers, in_bandwidth, out_bandwidth)
	custom_multiplayer.network_peer = _peer