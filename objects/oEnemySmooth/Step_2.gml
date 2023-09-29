motion_add(point_direction(x,y,planner.x,planner.y),accelSpeed)

if (accelSpeed > moveSpeed) accelSpeed = moveSpeed

playerX = oPlayer.x
playerY = oPlayer.y

with(planner)
{
	x = follower.x
	y = follower.y
	plan(other.playerX,other.playerY)
}