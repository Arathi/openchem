# 圆角矩形
@tool
extends Node2D


@export var width: float = 80:
	set(value):
		width = value
		update()

@export var height: float = 80:
	set(value):
		height = value
		update()

@export var radius: float = 5:
	set(value):
		radius = value
		update()

@export var color: Color = Color("#000000"):
	set(value):
		color = value
		update()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _draw():
	draw_rect(Rect2(radius, 0, width-2*radius, height), color, true)
	draw_rect(Rect2(0, radius, width, height-2*radius), color, true)
	draw_circle(Vector2(radius, radius), radius, color)
	draw_circle(Vector2(width - radius, radius), radius, color)
	draw_circle(Vector2(radius, height - radius), radius, color)
	draw_circle(Vector2(width - radius, height - radius), radius, color)


func update():
	queue_redraw()

