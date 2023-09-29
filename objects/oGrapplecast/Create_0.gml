dir = point_direction(x,y,mouse_x,mouse_y)
move_contact_solid(dir,400)
if distance_to_object(oSolid) < 2
{
	global.collisionX = x
	global.collisionY = y
	global.canGrapple = "true"
} else global.canGrapple = "false"
instance_destroy()