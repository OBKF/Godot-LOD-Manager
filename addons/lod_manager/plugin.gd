tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("LODManager", "Node", 
		preload("res://addons/lod_manager/lod_manager.gd"), 
		preload("res://addons/lod_manager/lod_manager_icon.svg"))
	pass

func _exit_tree():
	remove_custom_type("LODManager")
	pass
