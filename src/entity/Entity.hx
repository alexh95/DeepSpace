package entity;

import h2d.RenderContext;
import h2d.Sprite;
import h3d.Matrix;
import h3d.Vector;
import hxd.Key;

class Entity 
{
	public var mass : Float;
	public var position : Vector;
	public var angle : Float;
	
	public var velocity : Vector;
	
	public var friction : Float;
	public var maxSpeed : Float;
	
	public function new() 
	{
		mass = 0.;
		position = new Vector();
		angle = 0.;
		
		velocity = new Vector();
		
		friction = 0.;
		maxSpeed = 0.;
	}
	
	public function move(force : Vector, dt : Float) : Void
	{
		var acceleration = force.clone();
		acceleration.scale3(1. / mass);
		var newVelocity = velocity.add(acceleration).sub(new Vector());
		var frictionLoss : Vector = newVelocity.clone();
		frictionLoss.scale3(friction * dt);
		newVelocity.sub(frictionLoss).add(new Vector());
		var speed = newVelocity.length();
		if (speed > maxSpeed && maxSpeed > 0.)
		{
			newVelocity.scale3(maxSpeed / speed);
		}
		var newPosition = position.add(newVelocity).sub(new Vector());
		
		velocity = newVelocity;
		position = newPosition;
	}
	
}
