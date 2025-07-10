class_name GridDrawer
extends Node2D
# 图层绘制器，用于在填充图层上绘制网格。

## 用于填充和绘制网格的图块层
@export var fill_map:TileMapLayer
## 跟随高亮的相机
@export var follow_camera:PhantomCamera2D
## 用于给摄像机追踪高亮图块位置的目标节点
@export var high_light_camera_follow:Node2D

@export_category("展示模式")
@export var show_grid:bool = true
@export var show_highlight:bool = false
@export var show_limit:bool = false
@export var show_sights:bool = false

@export_category("网格颜色")
@export var grid_color:Color = Color(1, 1, 1, 0)
@export var grid_outline_color: Color = Color(1, 1, 1, 0.4)
@export var limit_color: Color = Color(1,0.5,1,0.3)
@export var limit_outline_color: Color = Color(1,0.5,1,0.4)
@export var highlight_color: Color = Color(1, 1, 0, 0.3)
@export var highlight_outline_color: Color = Color(0.5, 1, 1, 0.4)
@export var sight_color: Color = Color(0, 1, 1, 0.3)
@export var sight_outline_color: Color = Color(0, 1, 1, 0.4)

var tile_size:Vector2i

var limit_array:Array[Vector2i]
var highlight:Vector2i
var sight_dict:Dictionary[String,Array]
		
func _ready() -> void:
	tile_size = fill_map.tile_set.tile_size
	fill_map.modulate = Color(1,1,1,1)
	
	if show_grid or show_limit or show_highlight or show_sights:
		queue_redraw()

func focus_highlight():
	if follow_camera and high_light_camera_follow:		
		follow_camera.set_follow_target(high_light_camera_follow)

func update() -> void:
	queue_redraw()

func update_highlight(new_pos:Vector2i):
	var local_pos = fill_map.map_to_local(new_pos)
	# if limit_camera:
	# 	var limits = Rect2(limit_camera.limit_top,limit_camera.limit_left,\
	# 		limit_camera.limit_right-limit_camera.limit_left,\
	# 		limit_camera.limit_bottom-limit_camera.limit_top)
	# 	if !limits.has_point(new_pos):
	# 		return
	highlight = new_pos
	if high_light_camera_follow:
		high_light_camera_follow.position = local_pos

	

func update_sight_dict(id:String,val:Array):
	sight_dict[id] = val

func clean_sight_dict(id:String):
	sight_dict.erase(id)

func _draw() -> void:
	if show_limit:
		for limit in limit_array:
			_draw_grid(limit,limit_color,limit_outline_color)
	if show_highlight:
		_draw_grid(highlight,highlight_color,highlight_outline_color)
	if show_sights:
		for value in sight_dict.values():
			for sight in value:
				_draw_grid(sight,sight_color,sight_outline_color)
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
