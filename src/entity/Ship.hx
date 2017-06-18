package entity;

import entity.Entity;
import h2d.Sprite;
import h2d.Tile;
import h3d.Matrix;
import h3d.Vector;
import hxd.Key;
import hxd.Res;

class Ship extends Sprite 
{

	public var animation : Animation;
	public var entity : Entity;
	
	public var pixelsPerMeter : Float;
	
	public var baseAcceleration : Float;
	public var baseAngularSpeed : Float;
	private var directionRotationMatrix : Matrix;
	
	public function new(?parent : Sprite) 
	{
		super(parent);
		
		var shipTiles : Tile = Res.ShipSpreadSheet.toTile();
		var tileWidth : Int = Std.int(shipTiles.width / 3);
		var tileHeight : Int = Std.int(shipTiles.height / 3);
		var tileXCount : Int = Std.int(shipTiles.width / tileWidth);
		var tileYCount : Int = Std.int(shipTiles.height / tileHeight);
		var tileDX : Int = -(tileWidth >> 1);
		var tileDY : Int = -(tileHeight >> 1);
		var tiles : Array<Array<Tile>> = 
		[
			for ( x in 0...tileXCount) 
			[
				for ( y in 0...tileYCount) 
					shipTiles.sub(
						x * tileWidth, y * tileHeight, 
						tileWidth, tileHeight, 
						tileDX, tileDY)
			]
		];
		
		animation = new Animation(tiles, this);
		entity = new Entity();
		
		directionRotationMatrix = new Matrix();
	}
	
	public function update(dt : Float) : Void
	{
		var up : Bool = Key.isDown(Key.W);
		var down : Bool = Key.isDown(Key.S);
		var left : Bool = Key.isDown(Key.A);
		var right : Bool = Key.isDown(Key.D);
		var space : Bool = Key.isDown(Key.SPACE);
		
		var accForward : Bool = up && !down;
		var accBackward : Bool = down && !up;
		var noAcc : Bool = !accForward && !accBackward;
		
		var turnLeft : Bool = left && !right;
		var turnRight : Bool = right && !left;
		var noTurn : Bool = !turnLeft && !turnRight;
		
		var tileX : Int = 0;
		var tileY : Int = 0;
		
		if (noAcc) tileX = 0;
		else if (accForward) tileX = 1;
		else if (accBackward) tileX = 2;
		
		if (noTurn) tileY = 0;
		else if (turnLeft) tileY = 1;
		else if (turnRight) tileY = 2;
		
		animation.setFrame(tileX, tileY);
		
		var acceleration : Vector = new Vector();
		if (accForward) acceleration = new Vector(baseAcceleration, 0.);
		else if (accBackward) acceleration = new Vector(-baseAcceleration, 0.);
		
		if (turnLeft) 
		{
			entity.angle += dt * baseAngularSpeed;
			while (entity.angle >= 2 * Math.PI) entity.angle -= 2 * Math.PI;
		}
		else if (turnRight) 
		{
			entity.angle -= dt * baseAngularSpeed;
			while (entity.angle < 0) entity.angle += 2 * Math.PI;
		}
		
		directionRotationMatrix.initRotateZ(entity.angle);
		acceleration.transform(directionRotationMatrix);
		
		if (noAcc && space)
		{
			var movingDirection : Vector = entity.velocity.clone();
			movingDirection.normalize();
			
			acceleration = movingDirection.clone();
			if (entity.velocity.length() <= baseAcceleration)
			{
				acceleration.scale3(-entity.velocity.length());
			}
			else 
			{
				acceleration.scale3(-baseAcceleration);
			}
		}
		
		entity.move(acceleration);
		
		var screenCoordinates : Vector = entity.position.clone();
		screenCoordinates.scale3(pixelsPerMeter);
		
		var screenAngle : Float = Math.PI / 2 - entity.angle;
		
		x = screenCoordinates.x;
		y = -screenCoordinates.y;
		rotation = screenAngle;
	}
	
}
