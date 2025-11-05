extends MeshInstance3D

@export var particles: CPUParticles3D = null
@export var cloud: Mesh = null

var clones = []
var time = 0.0
var last = 0

func initialize():
	var frequency = 3
	var data = MeshDataTool.new()
	var tool = SurfaceTool.new()
	print("LOL "+str(cloud.get_surface_count()))
	tool.begin(Mesh.PRIMITIVE_POINTS)
	tool.append_from(cloud, 0, Transform3D.IDENTITY)
	var array = tool.commit()
	print(str(data.create_from_surface(array, 0)))
	print("LMAO "+str(data.get_vertex_count()))
	data = MeshDataTool.new()
	tool = SurfaceTool.new()
	tool.begin(Mesh.PRIMITIVE_LINES)
	tool.append_from(mesh, 0, Transform3D.IDENTITY)
	array = tool.commit()
	data.create_from_surface(array, 0)
	var total = 0
	var positions = []
	for i in range(data.get_edge_count()):
		if i%frequency != 0:
			continue
		var left = data.get_vertex(data.get_edge_vertex(i, 0))
		var right = data.get_vertex(data.get_edge_vertex(i, 1))
		for j in range(frequency):
			var position = left.lerp(right, float(j)/float(frequency))
			positions.append(position)
	if data.get_edge_count() == 0:
		for i in range(data.get_vertex_count()):
			positions.append(data.get_vertex(i))
	for position in positions:
		var clone = particles.duplicate()
		clone.visible = visible
		clone.position = position
		add_child(clone)
		clones.append(clone)
		clone.show()
		total += 1
		print(total)

func _ready():
	initialize()

func _process(delta):
	delta *= 0.1
	rotate_x(randf_range(-PI, PI)*delta)
	rotate_y(randf_range(-PI, PI)*delta)
	rotate_z(randf_range(-PI, PI)*delta)
	"""
	time += delta
	print(str(time))
	print(str(last))
	if int(time) == last:
		return
	last = int(time)
	for clone in clones:
		remove_child(clone)
		clone.queue_free()
	clones.clear()
	initialize()
	"""
