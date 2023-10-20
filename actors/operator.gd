@tool
class_name Operator
extends Node2D


const font = preload("res://assets/fonts/ipix_12px.ttf")
const COLOR_RED = Color("#ff0000")
const COLOR_BLUE = Color("#0000ff")
const COLOR_BORDER = Color("#000000")
const COLOR_UNKNOWN = Color("#202020")

const RED_SCALE = 0.333
const BLUE_SCALE = 0.666

const BALL_RADIUS_SCALE = 0.166
const TRIANGLE_HEIGHT_SCALE = 0.15


enum Layer {
	Red,
	Blue,
}


enum Type {
	None = 0,
	Diversion,
	GrabDrop,
}


enum Direction {
	Up,
	Right,
	Down,
	Left,
}


enum GrabDrop {
	Toggle,
	Grab,
	Drop,
}

@export_group("编辑器属性", "editor_")
@export var editor_size: float = 100:
	set(value):
		editor_size = value
		update_editor()


func update_editor():
	if Engine.is_editor_hint():
		update()


@export_group("样式")
@export var font_scale: float = 0.125:
	set(value):
		font_scale = value
		update()

# 最大不能超过sqrt(2)/6约为0.2357，否则两个圆会重叠
@export_range(0.150, 0.2357, 0.0001) var radius_scale: float = 0.23:
	set(value):
		radius_scale = value
		update()

@export var single_line_factor: float = 1:
	set(value):
		single_line_factor = value
		update()

@export var double_line_factor: float = 0.5:
	set(value):
		double_line_factor = value
		update()

@export_group("操作")
@export var layer: Layer = Layer.Red:
	set(value):
		layer = value
		update()

@export var type: Type = Type.None:
	set(value):
		type = value
		update()

@export var data: int = 0:
	set(value):
		data = value
		update()

@export var element_number: int = 0:
	set(value):
		element_number = value
		update()


var parent: Block:
	get:
		if has_node(".."):
			var node = get_node("..")
			if node is Block:
				return node
		return null

var size: float:
	get:
		if parent != null:
			return parent.size
		return editor_size

var radius: float:
	get:
		return size * radius_scale


func _ready():
	update()
	pass


func _process(delta):
	pass


func _draw():
	match type:
		Type.Diversion:
			draw_diversion()
		Type.GrabDrop:
			draw_grab_drop()
			
	pass


func draw_diversion():
	var dir: Direction = data % 4
	match dir:
		Direction.Up:
			draw_triangle()
	pass


func draw_triangle():
	var origin = Vector2(0, 0)
	if layer == Layer.Red:
		origin.x = 0
	elif layer == Layer.Blue:
		pass
	pass


func draw_grab_drop():
	var gd: GrabDrop = data % 3
	var font_size = 0
	var text = ""
	var centre: Vector2 = draw_ball()

	font_size = size * font_scale
	
	match gd:
		GrabDrop.Toggle:
			var pos = Vector2(centre.x - radius, centre.y - radius + font_size * double_line_factor)
			draw_strings(pos, ["Grab", "Drop"], font_size)
		GrabDrop.Grab:
			var pos = Vector2(centre.x - radius, centre.y - radius + font_size * single_line_factor)
			draw_strings(pos, ["Grab"], font_size)
		GrabDrop.Drop:
			var pos = Vector2(centre.x - radius, centre.y - radius + font_size * single_line_factor)
			draw_strings(pos, ["Drop"], font_size)
	
	pass


func draw_strings(pos: Vector2, lines: Array[String], font_size: int):
	var width = size / 3
	var offset_y = 0
	for text in lines:
		offset_y += font_size
		draw_string(
			font,
			Vector2(pos.x, pos.y + offset_y),
			text,
			HORIZONTAL_ALIGNMENT_CENTER,
			radius * 2,
			font_size
		)
	pass


func draw_ball() -> Vector2:
	var centre = Vector2(0, 0)
	var color: Color = COLOR_UNKNOWN
	if layer == Layer.Red:
		centre.x = size / 3
		centre.y = size / 3
		color = COLOR_RED
	elif layer == Layer.Blue:
		centre.x = size * 2 / 3
		centre.y = size * 2 / 3
		color = COLOR_BLUE
	draw_circle(centre, radius, COLOR_BORDER)
	draw_circle(centre, radius - 1, color)
	return centre


func update():
	if !is_node_ready():
		return
	
	match type:
		Type.Diversion:
			pass
		Type.GrabDrop:
			pass

	queue_redraw()


func update_grab_drop():
	var gd: GrabDrop = data % 3
	match gd:
		GrabDrop.Toggle:
			pass
		GrabDrop.Grab:
			pass
		GrabDrop.Drop:
			pass
