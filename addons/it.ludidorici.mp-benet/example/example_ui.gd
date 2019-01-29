extends Control

const PORT = 8081
const HOST = "127.0.0.1"

func _ready():
	var mode : OptionButton = $Panel/VBoxContainer/RPC/Mode
	mode.add_item("RELIABLE", NetworkedMultiplayerPeer.TRANSFER_MODE_RELIABLE)
	mode.add_item("ORDERED", NetworkedMultiplayerPeer.TRANSFER_MODE_UNRELIABLE_ORDERED)
	mode.add_item("UNRELIABLE", NetworkedMultiplayerPeer.TRANSFER_MODE_UNRELIABLE)
	mode = $Panel/VBoxContainer/Bytes/Mode
	mode.add_item("RELIABLE", NetworkedMultiplayerPeer.TRANSFER_MODE_RELIABLE)
	mode.add_item("ORDERED", NetworkedMultiplayerPeer.TRANSFER_MODE_UNRELIABLE_ORDERED)
	mode.add_item("UNRELIABLE", NetworkedMultiplayerPeer.TRANSFER_MODE_UNRELIABLE)
	$Panel/BENetNode/Game.connect("update_ping", self, "_update_ping")

func _update_ping(state):
	$Panel/VBoxContainer/Pings.clear()
	for k in state:
		$Panel/VBoxContainer/Pings.add_item("%d - %d" % [k, state[k]])

func _on_Server_pressed():
	if $Panel/BENetNode.start_server(PORT) == OK:
		$Panel/VBoxContainer/Create/Close.disabled = false
		$Panel/VBoxContainer/Create/Server.disabled = true
		$Panel/VBoxContainer/Create/Client.disabled = true
		$Panel/VBoxContainer/Bytes/SendBytes.disabled = false
		$Panel/VBoxContainer/RPC/SendRPC.disabled = false

func _on_Client_pressed():
	if $Panel/BENetNode.start_client(HOST, PORT) == OK:
		$Panel/VBoxContainer/Create/Close.disabled = false
		$Panel/VBoxContainer/Create/Server.disabled = true
		$Panel/VBoxContainer/Create/Client.disabled = true
		$Panel/VBoxContainer/Bytes/SendBytes.disabled = false
		$Panel/VBoxContainer/RPC/SendRPC.disabled = false

func _on_Close_pressed():
	$Panel/BENetNode.close_connection()
	$Panel/VBoxContainer/Create/Close.disabled = true
	$Panel/VBoxContainer/Create/Server.disabled = false
	$Panel/VBoxContainer/Create/Client.disabled = false
	$Panel/VBoxContainer/Bytes/SendBytes.disabled = true
	$Panel/VBoxContainer/RPC/SendRPC.disabled = true

func _on_SendRPC_pressed():
	var mode : int = $Panel/VBoxContainer/RPC/Mode.get_selected_id()
	var channel : int = int($Panel/VBoxContainer/RPC/Channel.value)
	$Panel/BENetNode/Game.send_rpc(mode, channel)

func _on_SendBytes_pressed():
	var mode : int = $Panel/VBoxContainer/Bytes/Mode.get_selected_id()
	var channel : int = int($Panel/VBoxContainer/Bytes/Channel.value)
	$Panel/BENetNode/Game.send_bytes(mode, channel)