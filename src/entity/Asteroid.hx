package entity;

import entity.Entity;
import h2d.Bitmap;
import h2d.Sprite;
import h2d.Tile;
import h3d.Vector;
import hxd.Res;

class Asteroid extends Sprite 
{

	public var bitmap : Bitmap;
	public var entity : Entity;
	
	public var pixelsPerMeter : Float;
	
	public function new(?parent:Sprite) 
	{
		super(parent);
		
		var asteroidTile : Tile = Res.SmallAsteroid.toTile();
		asteroidTile.dx = -(asteroidTile.width >> 1);
		asteroidTile.dy = -(asteroidTile.height >> 1);
		bitmap = new Bitmap(asteroidTile, this);
		entity = new Entity();
		
		entity.position = new Vector(0., 20.);
		var tangentVelocity : Vector = entity.position.cross(new Vector(0., 0., 1.));
		tangentVelocity.normalize();
		tangentVelocity.scale3(2.);
		//entity.velocity = tangentVelocity;
	}
	
	public function update(dt : Float) : Void
	{
		//var tangentAcceleration : Vector = entity.position.cross(new Vector(0., 0., 1.));
		//tangentAcceleration.normalize();
		//tangentAcceleration.scale3(2. / 60.);
		/*
		var gravitationalAcceleration : Vector = entity.position.clone();
		gravitationalAcceleration.normalize();
		gravitationalAcceleration.scale3(-1.);
		gravitationalAcceleration.scale3(0.025);
		var gravitationalForce : Vector = gravitationalAcceleration.clone();
		gravitationalForce.scale3(entity.mass * dt);
		*/
		//var acceleration = tangentAcceleration.add(gravitationalAcceleration).sub(new Vector());
		//entity.move(acceleration, dt);
		//entity.move(gravitationalForce, dt);
		
		var screenCoordinates : Vector = entity.position.clone();
		screenCoordinates.scale3(pixelsPerMeter);
		
		x = screenCoordinates.x;
		y = -screenCoordinates.y;
		//rotation = screenAngle;
	}
	
}
