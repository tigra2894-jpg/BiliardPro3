
extends Node3D

const TABLE_LENGTH := 2.54
const TABLE_WIDTH := 1.27
const TABLE_HEIGHT := 0.76

const PLAY_LENGTH := 2.24
const PLAY_WIDTH := 1.12

const RAIL_HEIGHT := 0.12
const RAIL_WIDTH := 0.14

var green_material: StandardMaterial3D
var wood_material: StandardMaterial3D
var black_material: StandardMaterial3D


func _ready() -> void:
	create_materials()
	create_table()
	create_lights()
	create_camera()


func create_materials() -> void:
	green_material = StandardMaterial3D.new()
	green_material.albedo_color = Color("#087a3d")
	green_material.roughness = 0.85

	wood_material = StandardMaterial3D.new()
	wood_material.albedo_color = Color("#4a2412")
	wood_material.roughness = 0.7

	black_material = StandardMaterial3D.new()
	black_material.albedo_color = Color("#050505")
	black_material.roughness = 0.4


func create_table() -> void:
	# Cadrul mesei
	create_box(
		"TableFrame",
		Vector3(TABLE_LENGTH, 0.20, TABLE_WIDTH),
		Vector3(0, TABLE_HEIGHT - 0.10, 0),
		wood_material
	)

	# Suprafața verde
	create_box(
		"PlayingSurface",
		Vector3(PLAY_LENGTH, 0.05, PLAY_WIDTH),
		Vector3(0, TABLE_HEIGHT + 0.025, 0),
		green_material
	)

	# Mantinele laterale
	create_box(
		"RailTop",
		Vector3(PLAY_LENGTH, RAIL_HEIGHT, RAIL_WIDTH),
		Vector3(0, TABLE_HEIGHT + 0.11, TABLE_WIDTH / 2.0 - RAIL_WIDTH / 2.0),
		wood_material
	)

	create_box(
		"RailBottom",
		Vector3(PLAY_LENGTH, RAIL_HEIGHT, RAIL_WIDTH),
		Vector3(0, TABLE_HEIGHT + 0.11, -TABLE_WIDTH / 2.0 + RAIL_WIDTH / 2.0),
		wood_material
	)

	create_box(
		"RailLeft",
		Vector3(RAIL_WIDTH, RAIL_HEIGHT, TABLE_WIDTH),
		Vector3(-TABLE_LENGTH / 2.0 + RAIL_WIDTH / 2.0, TABLE_HEIGHT + 0.11, 0),
		wood_material
	)

	create_box(
		"RailRight",
		Vector3(RAIL_WIDTH, RAIL_HEIGHT, TABLE_WIDTH),
		Vector3(TABLE_LENGTH / 2.0 - RAIL_WIDTH / 2.0, TABLE_HEIGHT + 0.11, 0),
		wood_material
	)

	# Picioare
	var leg_height := TABLE_HEIGHT - 0.20

	for x in [-0.95, 0.95]:
		for z in [-0.43, 0.43]:
			create_box(
				"Leg",
				Vector3(0.14, leg_height, 0.14),
				Vector3(x, leg_height / 2.0, z),
				wood_material
			)


func create_box(
	node_name: String,
	size: Vector3,
	position: Vector3,
	material: Material
) -> MeshInstance3D:

	var mesh := BoxMesh.new()
	mesh.size = size

	var instance := MeshInstance3D.new()
	instance.name = node_name
	instance.mesh = mesh
	instance.position = position
	instance.material_override = material

	add_child(instance)

	return instance


func create_lights() -> void:
	var light := DirectionalLight3D.new()

	light.rotation_degrees = Vector3(-55, -25, 0)
	light.light_energy = 1.2
	light.shadow_enabled = true

	add_child(light)


func create_camera() -> void:
	var camera := Camera3D.new()

	camera.position = Vector3(0, 4.0, 3.8)
	camera.look_at_from_position(
		camera.position,
		Vector3(0, TABLE_HEIGHT, 0)
	)

	camera.current = true

	add_child(camera)
