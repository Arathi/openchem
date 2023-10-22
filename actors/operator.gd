@tool
extends Node2D


const font = preload("res://assets/fonts/NotoSans-Regular.ttf")

const Reactor = preload("res://actors/reactor.gd")

const COLOR_UNKNOWN = Color("#555555")
const COLOR_RED = Color("#ff0000")
const COLOR_BLUE = Color("#0000ff")
const COLOR_BORDER = Color("#000000")
const Layer = Reactor.Layer


enum Type {
	None,
	Diversion,
	Band,
	GrabDrop,
	InOut,
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

enum InOut {
	Alpha,
	Beta,
	Psi,
	Omega,
}


@export_group("样式")
@export var layer: Layer = Layer.Red:
	set(value):
		layer = value
		update()

@export_range(64, 240, 0.1) var size: float = 100:
	set(value):
		size = value
		update()

@export_range(0.15, 0.2357, 0.0001) var radius_scale: float = 0.23:
	set(value):
		radius_scale = value
		update()

@export_range(0.1, 1, 0.01) var text_size_scale: float = 0.15:
	set(value):
		text_size_scale = value
		update()

@export_range(0.1, 1, 0.01) var text_offset_scale: float = 0.25:
	set(value):
		text_offset_scale = value
		update()

@export_range(0.01, 1, 0.01) var height_scale: float = 0.08:
	set(value):
		height_scale = value
		update()

@export_group("数据")
@export var type: Type = Type.None:
	set(value):
		type = value
		update()

@export var data: int = 0:
	set(value):
		data = value
		update()


var centre: Vector2:
	get:
		var p = size / 3.0
		if layer == Layer.Blue:
			p *= 2
		return Vector2(p, p)

var color: Color:
	get:
		var index = layer % 2
		match index:
			Layer.Red: return COLOR_RED
			Layer.Blue: return COLOR_BLUE
		return COLOR_UNKNOWN


func _ready():
	pass


func _process(delta):
	pass


func _draw():
	match type:
		Type.Diversion:
			draw_diversion()
		Type.Band:
			draw_band()
		Type.GrabDrop:
			draw_grab_drop()
		Type.InOut:
			draw_in_out()
	pass


func draw_diversion():
	var dir: Direction = data % 4
	var cx = centre.x
	var cy = centre.y
	var h = size * height_scale
	
	var points = PackedVector2Array()
	match dir:
		Direction.Up:
			points.append(Vector2(cx, h))
			points.append(Vector2(cx-h, 2*h))
			points.append(Vector2(cx+h, 2*h))
		Direction.Right:
			points.append(Vector2(size-h, cy))
			points.append(Vector2(size-2*h, cy-h))
			points.append(Vector2(size-2*h, cy+h))
		Direction.Down:
			points.append(Vector2(cx, size-h))
			points.append(Vector2(cx-h, size-2*h))
			points.append(Vector2(cx+h, size-2*h))
		Direction.Left:
			points.append(Vector2(h, cy))
			points.append(Vector2(2*h, cy-h))
			points.append(Vector2(2*h, cy+h))

	draw_polygon(points, PackedColorArray([color]))


func draw_band():
	var sign: = data % 2
	match sign:
		0: draw_circle_text(["Band", "+"])
		1: draw_circle_text(["Band", "-"])
	pass


func draw_grab_drop():
	var gd: GrabDrop = data % 3
	match gd:
		GrabDrop.Toggle: draw_circle_text(["Grab", "Drop"])
		GrabDrop.Grab: draw_circle_text(["Grab"])
		GrabDrop.Drop: draw_circle_text(["Drop"])


func draw_in_out():
	var io: InOut = data % 4
	match io:
		InOut.Alpha: draw_circle_text(["In", "α"])
		InOut.Beta: draw_circle_text(["In", "β"])
		InOut.Psi: draw_circle_text(["Out", "ψ"])
		InOut.Omega: draw_circle_text(["Out", "ω"])


func draw_circle_text(lines: Array[String]):
	var radius = size * radius_scale
	draw_circle(centre, radius, color)
	var font_size = size * text_size_scale
	var offset_y = lines.size() * 0.5 * font_size - 2 * radius * text_offset_scale
	var index = 0
	for line in lines:
		var pos = Vector2(
			centre.x - radius, 
			centre.y - offset_y + index * font_size
		)
		draw_string(
			font, 
			pos, 
			line, 
			HORIZONTAL_ALIGNMENT_CENTER, 
			radius * 2, 
			font_size
		)
		index += 1


func update():
	queue_redraw()
	pass

