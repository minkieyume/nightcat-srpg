class_name GridDrawer
extends Node2D
# 图层绘制器，用于在填充图层上绘制网格。

@export var fill_map:TileMapLayer # 用于填充和绘制网格的图块层

@export_category("展示模式")
@export var show_grid:bool = true:
	set(s):
		show_grid = s
		queue_redraw()
@export var show_highlight:bool = false:
	set(s):
		show_highlight = s
		queue_redraw()
@export var show_limit:bool = false:
	set(s):
		show_limit = s
		queue_redraw()

@export_category("网格颜色")
@export var grid_color:Color = Color(1, 1, 1, 0):
	set(c):
		grid_color = c
		queue_redraw()
@export var grid_outline_color: Color = Color(1, 1, 1, 0.4):
	set(c):
		grid_outline_color = c
		queue_redraw()
@export var limit_color: Color = Color(1,0.5,1,0.3):
	set(c):
		limit_color = c
		queue_redraw()
@export var limit_outline_color: Color = Color(1,0.5,1,0.4):
	set(c):
		limit_outline_color = c
		queue_redraw()
@export var highlight_color: Color = Color(1, 1, 0, 0.3):
	set(c):
		highlight_color = c
		queue_redraw()
@export var highlight_outline_color: Color = Color(0.5, 1, 1, 0.4):
	set(c):
		highlight_outline_color = c
		queue_redraw()

var tile_size:Vector2i

var limit_array:Array[Vector2i]:
	set(l):
		limit_array = l
		queue_redraw()
var highlight:Vector2i:
	set(h):
		highlight = h
		queue_redraw()

func _ready() -> void:
	tile_size = fill_map.tile_set.tile_size
	fill_map.modulate = Color(1,1,1,1)
	
	if show_grid or show_limit or show_highlight:
		queue_redraw()

func _draw() -> void:
	if show_limit:
		for limit in limit_array:
			_draw_grid(limit,limit_color,limit_outline_color)
	if show_highlight:
		_draw_grid(highlight,highlight_color,highlight_outline_color)
	if show_grid:
		_draw_grid_cells()

func _draw_grid_cells() -> void: # 在所有已使用的网格绘制网格线
	var used_cells = fill_map.get_used_cells()
	if show_highlight:
		used_cells.erase(highlight)
	if show_limit:
		for limit in limit_array:
			used_cells.erase(limit)
	for cell in used_cells:
		_draw_grid(cell,grid_color,grid_outline_color)


func _draw_grid(grid:Vector2i,color:Color,o_color:Color) -> void:
	# 绘制网格与边框
	var pos = fill_map.map_to_local(grid)
	var rect = Rect2(pos-Vector2(tile_size)/2,tile_size)
	draw_rect(rect,color) # 绘制网格
	draw_rect(rect,o_color,false) # 绘制网格边框
