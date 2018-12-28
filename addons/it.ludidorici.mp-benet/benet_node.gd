extends "custom_multiplayer.gd"

const BENetAPI = preload("benet_multiplayer_api.gd")

export var in_bandwidth = 0
export var out_bandwidth = 0
export(int, 3, 255, 1) var channels = 3 setget set_channels
export var max_peers = 32

var _peer : NetworkedMultiplayerENet = null

func _init():
	custom_multiplayer = BENetAPI.new()
	custom_multiplayer.set_root_node(self)

func _exit_tree():
	close_connection()

func set_channels(value):
	if value < BENetAPI.CHANNEL_MIN:
		value = BENetAPI.CHANNEL_MIN
	if value > BENetAPI.CHANNEL_MAX:
		value = BENetAPI.CHANNEL_MAX
	channels = value

func close_connection():
	if _peer != null:
		custom_multiplayer.network_peer = null
		_peer = null

func start_server(port : int, bind_ip : String = "*") -> int:
	assert(is_inside_tree())
	assert(_peer == null)
	_peer = NetworkedMultiplayerENet.new()
	_peer.channel_count = BENetAPI.CHANNEL_MIN + channels
	_peer.set_bind_ip(bind_ip)
	var err : int = _peer.create_server(port, max_peers, in_bandwidth, out_bandwidth)
	if err == OK:
		custom_multiplayer.network_peer = _peer
	else:
		_peer = null
	return err

func start_client(host : String, port : int) -> int:
	assert(is_inside_tree())
	assert(_peer == null)
	_peer = NetworkedMultiplayerENet.new()
	_peer.channel_count = BENetAPI.CHANNEL_MIN + channels
	var err : int = _peer.create_client(host, port, max_peers, in_bandwidth, out_bandwidth)
	if err == OK:
		custom_multiplayer.network_peer = _peer
	else:
		_peer = null
	return err