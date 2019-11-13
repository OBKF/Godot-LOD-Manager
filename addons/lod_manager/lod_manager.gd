extends Node

"""
This is a distance based LOD Manager that can switch the visibility
of all nodes that belong to certain LOD groups.

How to use:
	1- Add LOD group names (exp: 'default').
	2- Add LOD ranges (intervals to where the visibility of an object
		should be switched on/off) (exp: [0, 20, 40, 80, 160]).
	3- Add LOD group to the MeshInstance (exp: 'default_lod0').
	
Note:
	Groupes assigned to the MeshInstances should be named 'GroupName'+'_lod'+'X'
	where 'X' is the lod index (exp: default_lod0, default_lod1, ...).
	
Example of a StaticBody tree object that uses 'default' LOD:
	
	Tree_1 (StaticBody)
	|_Visual (Spatial)
	| |_TreeMesh_lod0 (MeshInstance, groups=['default_lod0'])
	| |_TreeMesh_lod0 (MeshInstance, groups=['default_lod1'])
	| |_TreeMesh_lod0 (MeshInstance, groups=['default_lod2'])
	| |_TreeMesh_lod0 (MeshInstance, groups=['default_lod3'])
	|_CollisionShape (CollisionShape)
	
Ps: Sorry if this is confusing :p, just see the example.
"""

# An Array that contains LOD group names
export(Array, String) var lods = ["default"]
# An Array that contains the range values associated with previus LOD groups 
export(Array, Array, int) var lod_ranges = [[0, 20, 40, 80, 160]]

var cam_pos = Vector3()

func _ready():
	# This is needed to prevent Null values from using the editor sometimes
	for i in range(lod_ranges.size()):
		for j in range(lod_ranges[i].size()):
			if not lod_ranges[i][j]:
				lod_ranges[i][j] = 0


# warning-ignore:unused_argument
func _process(delta):
	# Get the camera position
	cam_pos = get_viewport().get_camera().global_transform.origin
	
	# Loop over all LODs
	for i in range(lods.size()):
		# Loop over the range intervals of each LOD
		for j in range(lod_ranges[i].size()):
			# Generate LOD group names
			var lod_name = lods[i]+"_lod%d"%j
			# Get a list of all nodes that are in lod_name goup
			var objects = get_tree().get_nodes_in_group(lod_name)
			
			for object in objects:
				# Calculate the distance squared between each node and the camera
				var distance = object.global_transform.origin.distance_squared_to(cam_pos)
				# If the distance belongs to a LOD interval, the Node will be visible
				# or invisible otherwise
				if distance > pow(lod_ranges[i][j], 2) and distance <= pow(lod_ranges[i][j+1], 2):
					object.visible = true
				else:
					object.visible = false





