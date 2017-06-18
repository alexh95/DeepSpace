package entity;

import h2d.RenderContext;
import h2d.Sprite;
import h3d.Matrix;
import h3d.Vector;
import hxd.Key;

class Entity 
{
	
	public var position : Vector;
	
	public var angle : Float;
	public var velocity : Vector;
	
	public var maxSpeed : Float;
	
	public function new() 
	{
		position = new Vector();
		angle = 0.;
		velocity = new Vector();
	}
	
	public function move(acceleration : Vector) : Void
	{
		velocity = velocity.add(acceleration).sub(new Vector());
		var speed = velocity.length();
		if (speed > maxSpeed)
		{
			velocity.scale3(maxSpeed / speed);
		}
		position = position.add(velocity).sub(new Vector());
	}
	
}
