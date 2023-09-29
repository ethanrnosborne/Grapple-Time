global.collisionX = x
global.collisionY = y
global.canGrapple = "false"

draw_set_circle_precision(100)

width = 10
widthCount = 400
keyJump = 0
keyJumpTick = 0
keyJumpTickReleased = 0
keyLeft = 0
keyRight = 0

grappleX = 0
grappleY = 0
ropeX = 0
ropeY = 0
ropeAngleVelocity = 0
ropeAngleVelocityCap = 10
ropeAngle = 0
ropeLength = 0
state = "platform"

xspd = 0
yspd = 0

jumpHeight = 14

movespd = 10
accelspd = 0.5
decelspd = 0.5

coyoteTime = 0
coyoteTimeMax = 10

inputBuffer = 0
inputBufferMax = 2

wallBounce = 14
wallHeight = 14

laserTime = 0
laserLength = 25
global.laserX = 0
global.laserY = 0

function approach(_start,_end,_shift)
{
	if (_start < _end)
	{
		return min(_start + _shift,_end)
	} else
	{
		return max(_start - _shift,_end)
	}
}

function MoveLeftOrRight()
{
	if keyLeft
	{
		xspd = approach(xspd,-movespd,accelspd)
	} else if keyRight
	{
		xspd = approach(xspd,movespd,accelspd)
	} else
	{
		xspd = approach(xspd,0,decelspd)
	}
}

function Jump(_obj)
{
	if (yspd < 40) yspd += 0.6 // Gravity + Terminal Velocity
	
	if (keyJumpTick) && (place_meeting(x - 1,y,_obj)) && (!place_meeting(x ,y + yspd,_obj))
	{
		yspd = 0 - wallHeight
		xspd = wallBounce
	}
	if (keyJumpTick) && (place_meeting(x + 1,y,_obj)) && (!place_meeting(x ,y + yspd,_obj))
	{
		yspd = 0 - wallHeight
		xspd = 0 - wallBounce
	}
	
	if (coyoteTime > 0) coyoteTime-- // Coyote Timer
	if (place_meeting(x,y + 1,_obj)) coyoteTime = coyoteTimeMax // Reset
	
	if (keyJumpTick) && (coyoteTime > 0) // Coyote Jump
	{
		yspd = 0 - jumpHeight
		coyoteTime = 0
	}
	
	if (inputBuffer > 0) inputBuffer-- // Buffer Timer
	if (keyJumpTick) inputBuffer = inputBufferMax // Start Buffer Timer
	
	if (place_meeting(x,y+yspd,_obj)) && inputBuffer > 0 && yspd > 0 // Buffer jump
	{
		yspd = 0 - jumpHeight
		inputBuffer = 0
	}
	
	if (keyJumpTickReleased) && (yspd < 0)
	{
		yspd *= 0.5 // Variable jump height
	}
}

function Collide(_obj)
{
	if place_meeting(x+xspd, y, _obj)
	{
		while !place_meeting(x+sign(xspd), y, _obj)
		{
			x+= sign(xspd)
		}
		xspd = 0
		if state = "grapple"
		{
			ropeAngle = point_direction(grappleX,grappleY,x,y)
			ropeAngleVelocity = 0 - ropeAngleVelocity * 0.7
		}
	}
	if place_meeting(x, y + yspd, _obj)
	{
		while !place_meeting(x, y + sign(yspd), _obj)
		{
			y+= sign(yspd)
		}
		yspd = 0
		if state = "grapple"
		{
			ropeAngle = point_direction(grappleX,grappleY,x,y)
			ropeAngleVelocity = 0
		}  
	}
}

function UpdatePosition()
{
	x += xspd
	y += yspd
}

function Swing()
{
	var _ropeAngleAcceleration = -0.2 * dcos(ropeAngle) // Calculate Velocity
	ropeAngleVelocity += _ropeAngleAcceleration
	ropeAngle += ropeAngleVelocity
	ropeAngleVelocity *= 0.99// Damping, 0.99 or 0.98, not sure which one I like more
	
	ropeX = grappleX + lengthdir_x(ropeLength,ropeAngle)
	ropeY = grappleY + lengthdir_y(ropeLength,ropeAngle)
	
	xspd = ropeX - x
	yspd = ropeY - y
	
	if (keyJumpTick)
	{
		state = "platform"
		yspd = (ropeY - y) * 2
	}
}

function Grapple()
{
	instance_create_layer(x,y,0,oGrapplecast)
	grappleX = global.collisionX
	grappleY = global.collisionY
	ropeX = x
	ropeY = y
	ropeAngleVelocity = xspd * (dampen(xspd, 0.4)) //Damping for the xspd swing velocity
	show_debug_message(string(xspd) + "::" + string(ropeAngleVelocity)) 
	if (ropeAngleVelocity > ropeAngleVelocityCap) ropeAngleVelocity = ropeAngleVelocityCap
	if (ropeAngleVelocity < -ropeAngleVelocityCap) ropeAngleVelocity = -ropeAngleVelocityCap
	ropeAngle = point_direction(grappleX,grappleY,x,y)
	ropeLength = point_distance(grappleX,grappleY,x,y)
	if (global.canGrapple = "true") state = "grapple"
}

function CapSpeed(_x,_y,_y2)
{
	if (xspd > _x) xspd = approach(xspd,_x,0.2)
	if (xspd < -_x) xspd = approach(xspd,-_x,0.2)
	if (yspd > _y2) yspd = _y2
	if (yspd < -_y) yspd = -_y
}

function dampen(currentSpeed, dampeningSeed)
{
	
	// result must be between 0 and 1 where 1 is no dampening, and 0 is fully damp i.e. no speed at all	
	// we want a higher current speed to be dampened more than a lower current speed
	// 0-10  -> * 0.4
	// 10-20 -> * 0.2
	// 20-30 -> * 0.1
	// > 30  -> * 0.05
	if (currentSpeed > 30) {
		return 0.1;
	} else if (currentSpeed > 20) {
		return 0.2;
	} else if (currentSpeed > 10) {
		return 0.3;
	} else {
		return 0.4
	}
}

function ropeLengthChange(_change,_range)
{
	if (distance_to_object(oSolid) < _range)
	{
		if (x < global.collisionX) if (keyLeft) ropeLength += _change
		if (x > global.collisionX) if (keyLeft) ropeLength -= _change
		if (x < global.collisionX) if (keyRight) ropeLength -= _change
		if (x > global.collisionX) if (keyRight) ropeLength += _change
	}
}