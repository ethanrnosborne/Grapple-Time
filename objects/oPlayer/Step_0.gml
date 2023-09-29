keyJump = keyboard_check(vk_up) or keyboard_check(ord("W"))
keyJumpTick = keyboard_check_pressed(vk_up) or keyboard_check_pressed(ord("W"))
keyJumpTickReleased = keyboard_check_released(vk_up) or keyboard_check_released(ord("W"))
keyLeft = keyboard_check(vk_left) or keyboard_check(ord("A"))
keyRight = keyboard_check(vk_right) or keyboard_check(ord("D"))


//Change State to Grapple
if (mouse_check_button_pressed(mb_left)) && (mouse_y < y) && (!place_meeting(x,y+1,oSolid)) && state = "platform"
{
	Grapple()
}

if (mouse_check_button_pressed(mb_right)) && (laserTime = 0) instance_create_layer(x,y,0,oLaserCollision)

if (state = "platform")
{
	
	MoveLeftOrRight()
	Jump(oSolid)
	Collide(oSolid)
	Collide(oBreakable)
	CapSpeed(14,14,40)
}
if (state = "grapple")
{
	//ropeLengthChange(2,15)
	Swing()
	Collide(oSolid)
	Collide(oBreakable)
}
UpdatePosition()