extends MultiplayerAPI

var rpc_channel = 1 setget set_rpc_channel

func set_rpc_channel(channel):
	rpc_channel = channel
	if network_peer != null:
		network_peer.transfer_channel = channel

func broadcast(pkt : PoolByteArray, channel : int):
	send(0, pkt, channel)

func broadcast_ordered(pkt : PoolByteArray, channel : int):
	send_ordered(0, pkt, channel)

func broadcast_unreliable(pkt : PoolByteArray, channel : int):
	send_unreliable(0, pkt, channel)

func send(target : int, pkt : PoolByteArray, channel : int):
	assert(network_peer != null)
	network_peer.transfer_channel = channel
	send_bytes(pkt, target, NetworkedMultiplayerPeer.TRANSFER_MODE_RELIABLE)
	network_peer.transfer_channel = rpc_channel

func send_ordered(target : int, pkt : PoolByteArray, channel : int):
	assert(network_peer != null)
	network_peer.transfer_channel = channel
	send_bytes(pkt, target, NetworkedMultiplayerPeer.TRANSFER_MODE_UNRELIABLE_ORDERED)
	network_peer.transfer_channel = rpc_channel

func send_unreliable(target : int, pkt : PoolByteArray, channel : int):
	assert(network_peer != null)
	network_peer.transfer_channel = channel
	send_bytes(pkt, target, NetworkedMultiplayerPeer.TRANSFER_MODE_UNRELIABLE)
	network_peer.transfer_channel = rpc_channel

func rpc(node : Node, method : String, args=[]):
	rpc_id(0, node, method, args)

func rpc_unreliable(node : Node, method : String, args=[]):
	rpc_unreliable_id(0, node, method, args)

func rpc_ordered(node : Node, method : String, args=[]):
	rpc_ordered_id(0, node, method, args)

func rpc_id(id : int, node : Node, method : String, args=[]):
	node.callv("rpc_id", [method, id] + args)

func rpc_unreliable_id(id : int, node : Node, method : String, args=[]):
	node.callv("rpc_unreliable", [method, id] + args)

func rpc_ordered_id(id : int, node : Node, method : String, args=[]):
	assert(network_peer != null)
	network_peer.always_ordered = true
	node.callv("rpc_unreliable", [method, id] + args)
	network_peer.always_ordered = false