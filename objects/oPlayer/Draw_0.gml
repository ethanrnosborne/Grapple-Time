if (state = "grapple") draw_line_width_color(grappleX,grappleY,ropeX,ropeY,14,#432515,#432515)
for (var i = 0; i < 10; i += 1)
{
	draw_circle_color(x,y,widthCount,#ff0000,#ff0000,true)
	widthCount--
}
widthCount = 400

if (laserTime > 0) && (global.canLaser = "true")
{
	draw_line_width_color(x,y,global.laserX,global.laserY,laserTime - 1,#ff0000,#ffff00)
	draw_circle_color(global.laserX,global.laserY,laserTime - 1,#ffff00,#ffff00,false)
	laserTime--
}

draw_self()