@tool
class_name Block
extends Node2D


const OperatorActor = preload("res://actors/operator.tscn")


const COLOR_TL_BR = Color("#202020")
const COLOR_BL_TR = Color("#1A1A1A")
const COLOR_MIDDLE = Color("#141414")


enum Position {
	TL_BR,
	BL_TR,
	MIDDLE,
}


@export var editor_size: float = 100
@export var editor_radius: float = 5
@export var editor_type: Blocks.Type = Blocks.Type.None


var parent: Blocks:
	get:
		var parent_path = ".."
		if has_node(parent_path):
			var node = get_node(parent_path)
			if node is Blocks:
				return node
		return null

var size: float:
	get:
		if parent != null:
			return parent.block_size
		return 100

var radius: float:
	get:
		if parent != null:
			return parent.block_radius
		return 5

var type: Blocks.Type:
	get:
		if parent != null:
			return parent.type
		return Blocks.Type.None


var color: Color:
	get:
		match type:
			Blocks.Type.Alpha, Blocks.Type.Omega: return COLOR_TL_BR
			Blocks.Type.Beta, Blocks.Type.Psi: return COLOR_BL_TR
		return COLOR_MIDDLE


func _enter_tree():
	#var op_red = OperatorActor.instantiate()
	#op_red.name = "op_red"
	#op_red.layer = Operator.Layer.Red
	#add_child(op_red)
	
	#var op_blue = OperatorActor.instantiate()
	#op_blue.name = "op_blue"
	#op_blue.layer = Operator.Layer.Blue
	#add_child(op_blue)
	
	pass


func _ready():
	queue_redraw()
	pass


func _process(delta):
	pass


func _draw():
	draw_rect(
		Rect2(0, radius, size, size - 2*radius),
		color,
		true,
	)
	draw_rect(
		Rect2(radius, 0, size-2*radius, size),
		color,
		true,
	)
	draw_circle(
		Vector2(radius, radius),
		radius,
		color,
	)
	draw_circle(
		Vector2(size-radius, radius),
		radius,
		color,
	)
	draw_circle(
		Vector2(radius, size-radius),
		radius,
		color,
	)
	draw_circle(
		Vector2(size-radius, size-radius),
		radius,
		color,
	)


func update():
	queue_redraw()
	pass

