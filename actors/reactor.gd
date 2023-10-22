@tool
extends Node2D


const WIDTH = 10
const HEIGHT = 8

const CellActor = preload("res://actors/round_rect.tscn")
const Cell = preload("res://actors/round_rect.gd")

const OperActor = preload("res://actors/operator.tscn")
const Operator = preload("res://actors/operator.gd")

const font = preload("res://assets/fonts/NotoSans-Regular.ttf")

enum Type {
	None,
	Alpha,
	Beta,
	Psi,
	Omega,
}

enum Layer {
	Red,
	Blue,
}


@export_group("样式")
@export var text_color: Color = Color("#46464646"):
	set(value):
		text_color = value
		update()

@export_range(0, 1, 0.01) var font_size_scale: float = 0.62:
	set(value):
		font_size_scale = value
		update()

@export_range(0, 1, 0.01) var offset_y_scale: float = 0.67:
	set(value):
		offset_y_scale = value
		update()

@export_group("方块", "cell_")
@export var cell_size: float = 80:
	set(value):
		cell_size = value
		update()

@export var cell_gap: float = 2:
	set(value):
		cell_gap = value
		update()

@export var cell_color_alpha_omega: Color = Color("#202020"):
	set(value):
		cell_color_alpha_omega = value
		update()

@export var cell_color_beta_psi: Color = Color("#1A1A1A"):
	set(value):
		cell_color_beta_psi = value
		update()

@export var cell_color_middle: Color = Color("#141414"):
	set(value):
		cell_color_middle = value
		update()


var cell_radius: float:
	get:
		return cell_size / 16.0

var unit: float:
	get:
		return cell_size + cell_gap


@onready var cells: Node2D = $cells
@onready var texts: Node2D = $texts
@onready var ops_red: Node2D = $ops_red
@onready var ops_blue: Node2D = $ops_blue


func get_cell_name(x: int, y: int) -> String:
	return "cell_%d_%d" % [x, y]


func get_op_name(layer: Layer, x: int, y: int) -> String:
	match layer:
		Layer.Red: "op_%d_%d" % [x, y]
		Layer.Blue: "op_%d_%d" % [x, y]
	return ""


func create_cell(x: int, y: int) -> Cell:
	var cell: Cell = CellActor.instantiate()
	cell.name = get_cell_name(x, y)
	return cell


func create_op(layer: Layer, x: int, y: int) -> Operator:
	var op: Operator = OperActor.instantiate()
	op.name = get_op_name(layer, x, y)
	return op


func _ready():
	update()
	pass


func _process(delta):
	pass


func get_type(x: int, y: int) -> Type:
	if y >= 0 and y <= 3:
		if x >= 0 and x <= 3:
			return Type.Alpha
		elif x >= 6 and x <= 9:
			return Type.Psi
	if y >= 4 and y <= 7:
		if x >= 0 and x <= 3:
			return Type.Beta
		elif x >= 6 and x <= 9:
			return Type.Omega
	return Type.None


func _draw():
	draw_area_name(Type.Alpha)
	draw_area_name(Type.Beta)
	draw_area_name(Type.Psi)
	draw_area_name(Type.Omega)


func draw_area_name(type: Type):
	var area_name = ""
	var x = 0
	var y = 0
	var font_size = 4 * unit * font_size_scale
	
	match type:
		Type.Alpha: 
			area_name = "α"
			x = 0
			y = 4 * unit * offset_y_scale
		Type.Beta: 
			area_name = "β"
			x = 0
			y = 4 * unit + 4 * unit * offset_y_scale
		Type.Psi: 
			area_name = "ψ"
			x = 6 * unit
			y = 4 * unit * offset_y_scale
		Type.Omega: 
			area_name = "ω"
			x = 6 * unit
			y = 4 * unit + 4 * unit * offset_y_scale

	draw_string(
		font, 
		Vector2(x, y), 
		area_name, 
		HORIZONTAL_ALIGNMENT_CENTER, 
		4 * unit, 
		font_size, 
		text_color
	)


func update():
	if !is_node_ready():
		print("节点%s未准备就绪，无法更新" % name)
		return

	for y in HEIGHT:
		for x in WIDTH:
			# cells
			var cell_name = get_cell_name(x, y)
			var cell: Cell = null
			if cells.has_node(cell_name):
				cell = cells.get_node(cell_name)
			else:
				cell = create_cell(x, y)
				cells.add_child(cell)
			
			cell.width = cell_size
			cell.height = cell_size
			cell.radius = cell_radius
			
			cell.position.x = x * unit
			cell.position.y = y * unit
			
			var type = get_type(x, y)
			match type:
				Type.Alpha, Type.Omega: cell.color = cell_color_alpha_omega
				Type.Beta, Type.Psi: cell.color = cell_color_beta_psi
				_: cell.color = cell_color_middle

			# ops
			update_operator(Layer.Red, x, y)
			update_operator(Layer.Blue, x, y)

	queue_redraw()
	pass


func update_operator(layer: Layer, x: int, y: int):
	var op: Operator = null
	var ops: Node2D = null
	match layer:
		Layer.Red: ops = ops_red
		Layer.Blue: ops = ops_blue
	
	var op_name = get_op_name(layer, x, y)
	if ops.has_node(op_name):
		op = ops.get_node(op_name)
	else:
		op = create_op(layer, x, y)
		ops.add_child(op)
	
	pass
