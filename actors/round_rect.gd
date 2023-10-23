# 圆角矩形
@tool
extends Node2D

const Reactor = preload("res://actors/reactor.gd")

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

var x: int = 0
var y: int = 0


var parent: Reactor:
	get: 
		var node = get_parent()
		if node is Reactor:
			return node
		return null


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


func _input(event):
	var reactor = parent
	if reactor == null:
		return

	if event is InputEventMouseButton:
		var dx = event.position.x - self.global_position.x
		var dy = event.position.y - self.global_position.y
		
		if dx >= 0 and dx < width and dy >= 0 and dy < height:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				reactor.emit_signal("add_operator", x, y)
			if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
				# reactor.add_operator(x, y)
				pass

