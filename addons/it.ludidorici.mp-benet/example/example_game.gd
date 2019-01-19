extends Node

func _ready():
	multiplayer.connect("benet_packet", self, "network_packet")
	multiplayer.connect("network_peer_connected", self, "peer_connected")
	multiplayer.connect("network_peer_disconnected", self, "peer_disconnected")

func peer_connected(id):
	print("Peer conncted %d" % id)

func peer_disconnected(id):
	print("Peer disconnected %d" % id)

func network_packet(peer, pkt, channel):
	print("Got data %s from peer %d on channel %d" % [str(Array(pkt)), peer, channel])

remote func my_rpc(a_par : int):
	print("my_rpc called with parameter %d from peer %d on channel %d" % [a_par, multiplayer.get_rpc_sender_id(), multiplayer.get_rpc_channel()])

func send_rpc(mode : int, channel : int):
	match mode:
		NetworkedMultiplayerPeer.TRANSFER_MODE_RELIABLE:
			multiplayer.rpc(self, "my_rpc", [5], channel)
		NetworkedMultiplayerPeer.TRANSFER_MODE_UNRELIABLE_ORDERED:
			multiplayer.rpc_ordered(self, "my_rpc", [5], channel)
		NetworkedMultiplayerPeer.TRANSFER_MODE_UNRELIABLE:
			multiplayer.rpc_unreliable(self, "my_rpc", [5], channel)

func send_bytes(mode : int, channel : int):
	match mode:
		NetworkedMultiplayerPeer.TRANSFER_MODE_RELIABLE:
			multiplayer.broadcast(PoolByteArray([1,2,3]), channel)
		NetworkedMultiplayerPeer.TRANSFER_MODE_UNRELIABLE_ORDERED:
			multiplayer.broadcast_ordered(PoolByteArray([1,2,3]), channel)
		NetworkedMultiplayerPeer.TRANSFER_MODE_UNRELIABLE:
			multiplayer.broadcast_unreliable(PoolByteArray([1,2,3]), channel)