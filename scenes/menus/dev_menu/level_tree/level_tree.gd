extends Control

var levels_path: String = "res://scenes"
var root: TreeItem
var tree_items: Array
var files: Array
var scene_loaders: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	root = %LevelTree.create_item()
	root.set_text(0, "root")
	%LevelTree.item_activated.connect(_item_activated)
	_setup_items()

func _setup_items(path: String = levels_path, item: TreeItem = root) -> void:
	var dir = DirAccess.open(path)
	for subdir in dir.get_directories():
		var tree_item = %LevelTree.create_item(item)
		tree_item.set_text(0, subdir)
		tree_items.append(tree_item)
		_setup_items(path + "/" + subdir, tree_item)
	for file in DirAccess.get_files_at(path):
		if file.ends_with(".tscn"):# and not file.ends_with("level_parent.tscn"):
			var tree_item = %LevelTree.create_item(item)
			tree_item.set_text(0, file)
			tree_item.set_custom_color(0, Color.YELLOW)
			tree_item.set_meta(&"LevelSelectPath", path + "/" + file)
			tree_items.append(tree_item)

func _item_activated() -> void:
	var selected = %LevelTree.get_selected()
	if selected.has_meta(&"LevelSelectPath"):
		SceneManager.fade_scene_to_file(selected.get_meta(&"LevelSelectPath"))
		%LevelTree.release_focus()
	print("Activated!")
