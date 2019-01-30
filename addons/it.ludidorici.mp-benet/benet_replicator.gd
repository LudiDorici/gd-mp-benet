extends Node

var _scenes = Dictionary()

func register_scene(scene : PackedScene):
	_scenes[scene.resource_path] = scene

func has_scene(scene : String):
	return _scenes.has(scene)

func node_added(node : Node):
	var scene = node.get_meta("scene") if node.has_meta("scene") else null
	if scene != null and has_scene(scene) and node.get_network_master() == multiplayer.get_network_unique_id():
		var path = str(node.get_parent().get_path()).replace(get_parent().get_path(), ".")
		rpc("add_scene", scene, path)

func node_deleted(node : Node):
	var scene = node.get_meta("scene") if node.has_meta("scene") else null
	if scene != null and has_scene(scene) and node.get_network_master() == multiplayer.get_network_unique_id():
		rpc("del_scene", node.get_path())

remote func add_scene(scene : String, path : NodePath):
	if not _scenes.has(scene):
		print("Invalid scene %s" % scene)
		return
	var node = load(scene).instance()
	get_parent().get_node(path).add_child(node)

func del_scene(path : NodePath):
	var node = get_node(path)
	node.get_parent().remove_child(node)