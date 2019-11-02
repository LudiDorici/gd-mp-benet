extends Node

var _root : Node = null
var _scenes = Dictionary()

func set_root(root : Node):
	_root = root

func register_scene(scene : PackedScene):
	_scenes[scene.resource_path] = scene

func has_scene(scene : String):
	return _scenes.has(scene)

remote func add_scene(scene : String, path : NodePath, node_name : String):
	var rel_path = str(path).replace(_root.get_path(), "./")
	print(_root.get_path())
	print("OMGL %s" % rel_path)
	if not _scenes.has(scene) or _root.has_node(rel_path + "/" + node_name):
		print("Invalid scene %s" % scene)
		return
	var node = load(scene).instance()
	node.name = node_name
	_root.get_node(rel_path).add_child(node)

remote func del_scene(scene : String, path : NodePath):
	if not _scenes.has(scene) or not _root.has_node(path) or _root.get_node(path).filename != scene:
		print("Invalid scene %s or path %" % [scene, path])
	var node = _root.get_node(path)
	node.get_parent().remove_child(node)