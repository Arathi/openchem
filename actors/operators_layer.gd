extends Node2D


const OperatorActor = preload("res://actors/operator.tscn")


@export var editor_block_size: float = 100
@export var editor_block_gap: float = 3

@export var operators: PackedInt32Array = PackedInt32Array()

@onready var parent: Reactor = get_node("..")


var block_size: float:
	get:
		if parent != null:
			return parent.block_size
		return editor_block_size

var block_gap: float:
	get:
		if parent != null:
			return parent.block_gap
		return editor_block_gap


func _enter_tree():
	for y in 8:
		for x in 10:
			create_operator(x, y)
	pass


func create_operator(x: int, y: int):
	var name = "op_%d_%d" % [x, y]
	var operator = OperatorActor.instantiate()
	operator.name = name
	add_child(operator)
	pass


func _ready():
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update():
	var unit = block_size + block_gap
	for y in 8:
		for x in 10:
			var op_name = "op_%d_%d" % [x, y]
			var op: Operator = get_node(op_name)
			op.position.x = x * unit
			op.opsition.y = y * unit
	pass
