//Controller
gridSize = 32
global.grid = mp_grid_create(0,0,room_width/gridSize,room_height/gridSize,gridSize,gridSize)
mp_grid_add_instances(global.grid,oSolid,false)

//Planner
pathId = path_add()

//Plan function
function plan(_x,_y)
{
	mp_grid_path(global.grid,pathId,x,y,_x,_y,true)
	path_start(pathId,oEnemySmooth.moveSpeed,path_action_stop,true)
}