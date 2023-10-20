@tool
class_name Reactor
extends Node2D


@export var block_size: float = 100:
	set(value):
		block_size = value
		update()

@export var block_gap: float = 3:
	set(value):
		block_gap = value
		update()


@onready var blocks_mid: Blocks = $blocks_middle
@onready var blocks_alpha: Blocks = $blocks_alpha
@onready var blocks_beta: Blocks = $blocks_beta
@onready var blocks_psi: Blocks = $blocks_psi
@onready var blocks_omega: Blocks = $blocks_omega


func _ready():
	update()
	pass


func _process(delta):
	pass


func update():
	update_blocks(blocks_alpha, 0, 0)
	update_blocks(blocks_beta, 0, 4)
	update_blocks(blocks_mid, 4, 0)
	update_blocks(blocks_psi, 6, 0)
	update_blocks(blocks_omega, 6, 4)
	pass


func update_blocks(blocks: Blocks, x: int, y: int):
	blocks.block_size = block_size
	blocks.block_gap = block_gap
	
	var unit = block_size + block_gap
	blocks.position.x = x * unit
	blocks.position.y = y * unit
	print("正在更新%s：(%f, %f)" % [blocks.name, x, y])
	
	blocks.update()
	pass
