extends Node

onready var scene = get_parent().filename

# Called when the node enters the scene tree for the first time.
func _ready():
	if scene == "":
		print("Scene syncer must be child of an instanced scene")
		return
	if multiplayer.get_network_unique_id() != 1:
		return
	replicate()

func replicate():
	multiplayer.replicator.rpc("add_scene", scene, get_parent().get_parent().get_path(), get_parent().name)

func _exit_tree():
	multiplayer.replicator.rpc("del_scene", scene, get_parent().get_path())