extends MultiplayerAPI

const CHANNEL_MIN = 3
const CHANNEL_MAX = 255

signal benet_packet(id, packet, channel)

func _init():
	connect("network_peer_packet", self, "_peer_packet")

func _peer_packet(id, packet):
	emit_signal("benet_packet", id, packet, network_peer.get_last_packet_channel())

func _adjust_peer(mode : int, channel : int):
	assert(channel != 0) # Channel 0 is reserved!
	assert(channel < network_peer.channel_count)
	if mode == NetworkedMultiplayerPeer.TRANSFER_MODE_UNRELIABLE_ORDERED:
		network_peer.always_ordered = true
	network_peer.transfer_channel = channel

func _restore_peer(mode : int):
	if mode == NetworkedMultiplayerPeer.TRANSFER_MODE_UNRELIABLE_ORDERED:
		network_peer.always_ordered = false
	network_peer.transfer_channel = -1

func _send_bytes(pkt : PoolByteArray, target : int, mode : int, channel : int):
	_adjust_peer(mode, channel)
	send_bytes(pkt, target, mode)
	_restore_peer(mode)

func broadcast(pkt : PoolByteArray, channel : int):
	send(0, pkt, channel)

func broadcast_ordered(pkt : PoolByteArray, channel : int):
	send_ordered(0, pkt, channel)

func broadcast_unreliable(pkt : PoolByteArray, channel : int):
	send_unreliable(0, pkt, channel)

func send(target : int, pkt : PoolByteArray, channel : int):
	assert(network_peer != null)
	_send_bytes(pkt, target, NetworkedMultiplayerPeer.TRANSFER_MODE_RELIABLE, channel)

func send_ordered(target : int, pkt : PoolByteArray, channel : int):
	assert(network_peer != null)
	_send_bytes(pkt, target, NetworkedMultiplayerPeer.TRANSFER_MODE_UNRELIABLE_ORDERED, channel)

func send_unreliable(target : int, pkt : PoolByteArray, channel : int):
	assert(network_peer != null)
	_send_bytes(pkt, target, NetworkedMultiplayerPeer.TRANSFER_MODE_UNRELIABLE, channel)

func rpc(node : Node, method : String, args : Array = [], channel = -1):
	rpc_id(0, node, method, args, channel)

func rpc_ordered(node : Node, method : String, args : Array = [], channel : int = -1):
	rpc_ordered_id(0, node, method, args, channel)

func rpc_unreliable(node : Node, method : String, args : Array = [], channel : int = -1):
	rpc_unreliable_id(0, node, method, args, channel)

func rpc_id(id : int, node : Node, method : String, args : Array = [], channel : int = -1):
	_adjust_peer(NetworkedMultiplayerPeer.TRANSFER_MODE_RELIABLE, channel)
	node.callv("rpc_id", [id, method] + args)
	_restore_peer(NetworkedMultiplayerPeer.TRANSFER_MODE_RELIABLE)

func rpc_ordered_id(id : int, node : Node, method : String, args : Array = [], channel : int = -1):
	assert(network_peer != null)
	_adjust_peer(NetworkedMultiplayerPeer.TRANSFER_MODE_UNRELIABLE_ORDERED, channel)
	node.callv("rpc_unreliable", [id, method] + args)
	_restore_peer(NetworkedMultiplayerPeer.TRANSFER_MODE_UNRELIABLE_ORDERED)

func rpc_unreliable_id(id : int, node : Node, method : String, args : Array = [], channel : int = -1):
	_adjust_peer(NetworkedMultiplayerPeer.TRANSFER_MODE_UNRELIABLE, channel)
	node.callv("rpc_unreliable", [id, method] + args)
	_restore_peer(NetworkedMultiplayerPeer.TRANSFER_MODE_UNRELIABLE)