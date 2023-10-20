@tool
class_name Blocks
extends Node2D


const Block = preload("res://actors/block.gd")
const BlockActor = preload("res://actors/block.tscn")

const COLOR_NAME = Color("#464646", 0.5)
const FONT_SIZE_SCALE = 0.5
const LABEL_HEIGHT_SCALE = 0.9

enum Type {
	None,
	Alpha,
	Beta,
	Psi,
	Omega,
}


@export var type: Type = Type.None

@export_group("方块属性", "block_")
@export var block_size: float = 100:
	set(value):
		block_size = value
		update()

@export var block_radius: float = 5:
	set(value):
		block_radius = value
		update()

@export var block_gap: float = 3:
	set(value):
		block_gap = value
		update()


var blocks_name: String:
	get:
		if type == Type.Alpha:
			return "α"
		if type == Type.Beta:
			return "β"
		if type == Type.Psi:
			return "ψ"
		if type == Type.Omega:
			return "ω"
		return ""


@onready var blocks: Node2D = $blocks
@onready var label: Label = $label


func create_block(block_name: String) -> Block:
	var block: Block = BlockActor.instantiate()
	if block == null:
		print("%s创建失败" % block_name)
		return null

	block.set_name(block_name)
	blocks.add_child(block)
	return block


func get_block(block_name: String) -> Block:
	if blocks.has_node(block_name):
		var node = blocks.get_node(block_name)
		if node is Block:
			return node
	return null


func _ready():
	update()
	pass


func _process(delta):
	pass


func update():
	if !is_node_ready():
		return
	
	var width: int = 2
	var height: int = 8
	
	if type != Type.None:
		width = 4
		height = 4
	
	for y in height:
		for x in width:
			var block_name = "block_%d_%d" % [x, y]
			var block: Block = get_block(block_name)
			if block == null:
				block = create_block(block_name)
			
			if block != null:
				block.position.x = (block_size + block_gap) * x
				block.position.y = (block_size + block_gap) * y
				pass
	
	if type == Type.None:
		label.hide()
		pass
	else:
		label.size.x = (block_size + block_gap) * width
		label.size.y = (block_size + block_gap) * height * LABEL_HEIGHT_SCALE
		label.text = blocks_name
		
		var size = min(label.size.x, label.size.y) * FONT_SIZE_SCALE
		label.add_theme_font_size_override("font_size", size)
		label.add_theme_color_override("font_color", COLOR_NAME)
		
		label.show()

