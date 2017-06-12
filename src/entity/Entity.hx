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
	
	public var friction : Float;
	public var maxSpeed : Float;
	
	public function new() 
	{
		position = new Vector();
		angle = 0.;
		velocity = new Vector();
		friction = 0.;
	}
	
	public function move(acceleration : Vector) : Void
	{
		velocity = velocity.add(acceleration).sub(new Vector());
		velocity.scale3(1. - friction);
		var speed = velocity.length();
		if (speed > maxSpeed)
		{
			velocity.scale3(maxSpeed / speed);
		}
		position = position.add(velocity).sub(new Vector());
	}
	
}
